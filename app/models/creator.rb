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

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :primary,      -> { where(primary: true ) }
  scope :secondary,    -> { where(primary: false) }

  scope :collective,    -> { where(collective: true ) }
  scope :singular,      -> { where(collective: false) }

  scope :alphabetical, -> { order(Arel.sql("LOWER(creators.name)")) }
  scope :for_admin,    -> { eager }
  scope :for_site,     -> { viewable.includes(:posts).alphabetical }

  scope :eager,        -> { includes(:pseudonyms, :members) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # Credits.

  has_many :credits, dependent: :destroy
  has_many :works, through: :credits
  has_many :posts, through: :works

  # Contributions.

  has_many :contributions, dependent: :destroy
  has_many :contributed_works, through: :contributions,     source: :work, class_name: "Work"
  has_many :contributed_posts, through: :contributed_works, source: :post, class_name: "Post"

  # Related Creators.

  has_many :identities, dependent: :destroy
  has_many :pseudonyms, -> { order 'creators.name' }, through: :identities

  has_many :memberships, dependent: :destroy
  has_many :members, -> { order 'creators.name' }, through: :memberships

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
    return pseudonyms.to_a if primary

    return [] unless parent = Identity.find_by(pseudonym_id: self.id).try(:creator)

    [parent, parent.pseudonyms].flatten.reject { |p| p == self }.sort_by(&:name)
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

  def groups
    return if collective?

    Membership.where(member_id: self.id).map(&:creator).to_a.sort_by(&:name)
  end

  def colleagues
    groups.map { |g| g.members }.flatten.uniq.reject { |m| m == self }.sort_by(&:name)
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
