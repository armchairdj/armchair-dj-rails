# frozen_string_literal: true

require "wannabe_bool"

class Creator < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_NEW_IDENTITIES  = 5.freeze
  MAX_NEW_MEMBERSHIPS = 5.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Summarizable
  include Viewable
  include Booletania

  booletania_columns :primary, :collective

  #############################################################################
  # CLASS.
  #############################################################################

  def self.available_pseudonyms_for(creator)
    available_pseudonyms.union_all(creator.pseudonyms)
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :primary,   -> { where(primary: true ) }
  scope :secondary, -> { where(primary: false) }

  scope :collective, -> { where(collective: true ) }
  scope :singular,   -> { where(collective: false) }

  scope :eager, -> { includes(:pseudonyms, :members) }

  scope :alphabetical, -> { order(Arel.sql("LOWER(creators.name)")) }

  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.viewable.includes(:posts).alphabetical }

  scope :available_members,    -> { singular.alphabetical }

  scope :available_pseudonyms, -> {
    secondary.left_outer_joins(:reverse_identities).where(identities: { id: nil }).alphabetical
  }

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

  has_many :identities,         foreign_key:   :creator_id, dependent: :destroy
  has_many :reverse_identities, foreign_key: :pseudonym_id, dependent: :destroy,
    class_name: "Identity"

  has_many :pseudonyms, -> { order("creators.name") },
    through: :identities,         class_name: "Creator", source: :pseudonym

  has_many :real_identities, -> { order("creators.name") },
    through: :reverse_identities, class_name: "Creator", source: :creator

  # Memberships.

  has_many :memberships,         foreign_key: :creator_id, dependent: :destroy
  has_many :reverse_memberships, foreign_key:  :member_id, dependent: :destroy,
    class_name: "Membership"

  has_many :members, -> { order("creators.name") },
    through: :memberships,         class_name: "Creator", source: :member

  has_many :groups,  -> { order("creators.name") },
    through: :reverse_memberships, class_name: "Creator", source: :creator

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  # Identities.

  accepts_nested_attributes_for :identities,
    allow_destroy: true,
    reject_if:     proc { |attrs| attrs["pseudonym_id"].blank? }

  def prepare_identities
    count_needed = MAX_NEW_IDENTITIES + self.identities.length

    count_needed.times { self.identities.build }
  end

  def secondary?
    !primary?
  end

  def personae
    return pseudonyms if primary?

    return self.class.none unless real_identity

    aliases = real_identity.pseudonyms.where.not(id: self.id)
    parent  = self.class.where(id: real_identity.id)

    aliases.union_all(parent).alphabetical
  end

  def real_identity
    real_identities.first
  end

  # Memberships.

  accepts_nested_attributes_for :memberships,
    allow_destroy: true,
    reject_if:     proc { |attrs| attrs["member_id"].blank? }

  def prepare_memberships
    count_needed = MAX_NEW_MEMBERSHIPS + self.memberships.length

    count_needed.times { self.memberships.build }
  end

  def singular?
    !collective?
  end

  def colleagues
    return self.class.none unless singular? && groups.any?

    ids = groups.map(&:members).to_a.flatten.pluck(:id).reject { |id| id == self.id }.uniq

    Creator.where(id: ids).alphabetical
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  validates :primary,    inclusion: { in: [true, false] }
  validates :collective, inclusion: { in: [true, false] }

  #############################################################################
  # HOOKS.
  #############################################################################

  before_save :handle_identities

  def handle_identities
    return if self.primary?

    self.identities.destroy_all
  end

  private :handle_identities

  after_save :handle_memberships

  def handle_memberships
    return if self.collective?

    self.memberships.destroy_all
  end

  private :handle_memberships

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
      memo << {
        medium: key,
        roles: val.map { |h| h[:role] }.uniq.sort
      }

      memo
    end
  end
end
