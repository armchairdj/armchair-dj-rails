# frozen_string_literal: true

require "wannabe_bool"

class Creator < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_PSEUDONYMS_AT_ONCE  = 5.freeze
  MAX_REAL_NAMES          = 1.freeze

  MAX_MEMBERS_AT_ONCE     = 5.freeze
  MAX_GROUPS_AT_ONCE      = 5.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Summarizable
  include Viewable
  include Booletania

  booletania_columns :primary, :individual

  #############################################################################
  # CLASS.
  #############################################################################

  # Nothing so far.

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :primary,    -> { where(primary:  true ) }
  scope :secondary,  -> { where(primary:  false) }
  scope :individual, -> { where(individual: true ) }
  scope :collective, -> { where(individual: false) }

  scope :orphaned, -> { left_outer_joins(:inverse_identities).where(identities: { id: nil } ) }

  scope :available_groups,     -> { alphabetical.collective         }
  scope :available_members,    -> { alphabetical.individual         }
  scope :available_real_names, -> { alphabetical.primary            }
  scope :available_pseudonyms, -> { alphabetical.secondary.orphaned }

  scope :eager, -> { includes(:pseudonyms, :real_names, :members, :groups, :credits, :works, :posts) }

  scope :alphabetical, -> { order(Arel.sql("LOWER(creators.name)")) }

  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.viewable.alphabetical }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # Credits.

  has_many :credits, dependent: :destroy
  has_many :works, through: :credits
  has_many :posts, through: :works

  # Contributions.

  has_many :contributions, dependent: :destroy
  has_many :contributed_works, through: :contributions,     class_name: "Work", source: :work
  has_many :contributed_posts, through: :contributed_works, class_name: "Post", source: :post

  # Identities.

  has_many         :identities, dependent: :destroy, inverse_of: :real_name, foreign_key: :real_name_id
  has_many :inverse_identities, dependent: :destroy, inverse_of: :pseudonym, foreign_key: :pseudonym_id, class_name: "Identity"

  has_many :pseudonyms, -> { order("creators.name") }, through:         :identities, source: :pseudonym
  has_many :real_names, -> { order("creators.name") }, through: :inverse_identities, source: :real_name

  # Memberships.

  has_many         :memberships, dependent: :destroy, inverse_of: :group,  foreign_key: :group_id
  has_many :inverse_memberships, dependent: :destroy, inverse_of: :member, foreign_key: :member_id, class_name: "Membership"

  has_many :members, -> { order("creators.name") }, through:         :memberships, source: :member
  has_many  :groups, -> { order("creators.name") }, through: :inverse_memberships, source: :group

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  # Identities.

  accepts_nested_attributes_for :identities, allow_destroy: true,
    reject_if: proc { |attrs| attrs["pseudonym_id"].blank? }

  def prepare_identities
    count_needed = MAX_PSEUDONYMS_AT_ONCE + self.identities.length

    count_needed.times { self.identities.build }
  end

  accepts_nested_attributes_for :inverse_identities, allow_destroy: true,
    reject_if:  proc { |attrs| attrs["creator_id"].blank? }

  def prepare_inverse_identities
    count_needed = MAX_REAL_NAMES - self.inverse_identities.length

    count_needed.times { self.inverse_identities.build }
  end

  def secondary?
    !primary?
  end

  def real_name
    real_names.first
  end

  def personae
    return pseudonyms if primary?

    return self.class.none unless real_name

    aliases = real_name.pseudonyms.where.not(id: self.id)
    parent  = self.class.where(id: real_name.id)

    aliases.union_all(parent).alphabetical
  end

  def available_pseudonyms
    self.class.available_pseudonyms.union_all(self.pseudonyms).alphabetical
  end

  # Memberships.

  accepts_nested_attributes_for :memberships, allow_destroy: true,
    reject_if: proc { |attrs| attrs["member_id"].blank? }

  def prepare_memberships
    count_needed = MAX_MEMBERS_AT_ONCE + self.memberships.length

    count_needed.times { self.memberships.build }
  end

  accepts_nested_attributes_for :inverse_memberships, allow_destroy: true,
    reject_if: proc { |attrs| attrs["creator_id"].blank? }

  def prepare_inverse_memberships
    count_needed = MAX_GROUPS_AT_ONCE + self.inverse_memberships.length

    count_needed.times { self.inverse_memberships.build }
  end

  def collective?
    !individual?
  end

  def colleagues
    return self.class.none unless individual? && groups.any?

    ids = groups.map(&:members).to_a.flatten.pluck(:id).reject { |id| id == self.id }.uniq

    Creator.where(id: ids).alphabetical
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  validates :primary,    inclusion: { in: [true, false] }
  validates :individual, inclusion: { in: [true, false] }

  #############################################################################
  # HOOKS.
  #############################################################################

  before_validation :enforce_primariness

  def enforce_primariness
    if self.primary?
      self.inverse_identities.destroy_all
    else
      self.identities.destroy_all
    end
  end

  private :enforce_primariness

  before_validation :enforce_individuality

  def enforce_individuality
    if self.individual?
      self.inverse_memberships.destroy_all
    else
      self.memberships.destroy_all
    end
  end

  private :enforce_individuality

  #############################################################################
  # INSTANCE.
  #############################################################################

  def contributions_array
    self.contributions.viewable.map { |c| {
      medium: c.work.pluralized_human_medium,
      role:   c.human_role,
      work:   c.work.full_display_title
    } }
  end

  def contributions_by_role
    self.contributions_array.group_by{ |r| r[  :role] }.sort_by(&:first).to_h
  end

  def contributions_by_medium
    self.contributions_array.group_by{ |r| r[:medium] }.sort_by(&:first).to_h
  end

  def contributions_by_work
    self.contributions_array.group_by{ |r| r[  :work] }.sort_by(&:first).to_h
  end

  def media
    self.contributions.viewable.map(&:work).map(&:pluralized_human_medium).uniq.sort
  end

  def roles
    self.contributions.viewable.map(&:human_role).uniq.sort
  end

  def roles_by_medium
    self.contributions_by_medium.reduce([]) do |memo, (key, val)|
      memo << { medium: key, roles: val.map { |h| h[:role] }.uniq.sort }

      memo
    end
  end
end
