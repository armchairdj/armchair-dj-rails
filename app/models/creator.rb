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

  scope :primary,    -> { where(primary:     true) }
  scope :secondary,  -> { where(primary:    false) }
  scope :individual, -> { where(individual:  true) }
  scope :collective, -> { where(individual: false) }

  scope :orphaned, -> { left_outer_joins(:real_name_identities).where(identities: { id: nil } ) }

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
  has_many :contributed_works, through: :contributions,
    class_name: "Work", source: :work
  has_many :contributed_posts, through: :contributed_works,
    class_name: "Post", source: :post

  # Identities.

  has_many :pseudonym_identities, class_name: "Identity", dependent: :destroy,
    foreign_key: :real_name_id, inverse_of: :real_name
  has_many :real_name_identities, class_name: "Identity", dependent: :destroy,
    foreign_key: :pseudonym_id, inverse_of: :pseudonym

  has_many :pseudonyms, -> { order("creators.name") },
    through: :pseudonym_identities, source: :pseudonym
  has_many :real_names, -> { order("creators.name") },
    through: :real_name_identities, source: :real_name

  # Memberships.

  has_many :member_memberships, class_name: "Membership", dependent: :destroy,
    foreign_key: :group_id, inverse_of: :group
  has_many :group_memberships,  class_name: "Membership", dependent: :destroy,
  foreign_key: :member_id, inverse_of: :member

  has_many :members, -> { order("creators.name") },
    through: :member_memberships, source: :member
  has_many  :groups, -> { order("creators.name") },
    through: :group_memberships,  source: :group

  #############################################################################
  # ATTRIBUTES: pseudonym_identities
  #############################################################################

  accepts_nested_attributes_for :pseudonym_identities, allow_destroy: true,
    reject_if: :blank_or_primary?

  def blank_or_primary?(attrs)
    key = attrs["pseudonym_id"]

    return true if key.blank?
    return true if self.class.find(key).primary?
  end

  private :blank_or_primary?

  def prepare_pseudonym_identities
    MAX_PSEUDONYMS_AT_ONCE.times { self.pseudonym_identities.build }
  end

  def available_pseudonyms
    self.class.available_pseudonyms.union_all(self.pseudonyms).alphabetical
  end

  #############################################################################
  # ATTRIBUTES: real_name_identities
  #############################################################################

  accepts_nested_attributes_for :real_name_identities, allow_destroy: true,
    reject_if: :blank_or_secondary?

  def blank_or_secondary?(attrs)
    key = attrs["real_name_id"]

    return true if key.blank?
    return true if self.class.find(key).secondary?
  end

  private :blank_or_secondary?

  def prepare_real_name_identities
    count_needed = MAX_REAL_NAMES - self.real_name_identities.length

    count_needed.times { self.real_name_identities.build }
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

  #############################################################################
  # ATTRIBUTES: member_memberships
  #############################################################################

  accepts_nested_attributes_for :member_memberships, allow_destroy: true,
    reject_if: :blank_or_collective?

  def blank_or_collective?(attrs)
    key = attrs["member_id"]

    return true if key.blank?
    return true if self.class.find(key).collective?
  end

  private :blank_or_collective?

  def prepare_member_memberships
    MAX_MEMBERS_AT_ONCE.times { self.member_memberships.build }
  end

  #############################################################################
  # ATTRIBUTES: group_memberships
  #############################################################################

  accepts_nested_attributes_for :group_memberships, allow_destroy: true,
    reject_if: :blank_or_individual?

  def blank_or_individual?(attrs)
    key = attrs["group_id"]

    return true if key.blank?
    return true if self.class.find(key).individual?
  end

  private :blank_or_individual?

  def prepare_group_memberships
    MAX_GROUPS_AT_ONCE.times { self.group_memberships.build }
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

  def enforce_primariness
    if self.primary?
      self.real_name_identities.destroy_all
    else
      self.pseudonym_identities.destroy_all
    end
  end

  after_save :enforce_primariness

  private :enforce_primariness

  def enforce_individuality
    if self.collective?
      self.group_memberships.destroy_all
    else
      self.member_memberships.destroy_all
    end
  end

  after_save :enforce_individuality

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
