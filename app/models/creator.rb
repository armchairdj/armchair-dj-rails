# frozen_string_literal: true

class Creator < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Viewable

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
  scope :eager,        -> { all }
  scope :for_admin,    -> { eager }
  scope :for_site,     -> { viewable.includes(:posts).alphabetical }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # Contributions & Works.

  has_many :contributions, dependent: :destroy

  has_many :works, -> { where(contributions: {
    role: Contribution.roles["creator"] })
  }, through: :contributions, source: :work, class_name: "Work"

  has_many :contributed_works, -> { where.not(contributions: {
    role: Contribution.roles["creator"] })
  }, through: :contributions, source: :work, class_name: "Work"

  has_many :posts, through: :works

  # Related Creators.

  has_many :identities
  has_many :pseudonyms, -> { order 'creators.name' }, through: :identities

  has_many :memberships
  has_many :members, -> { order 'creators.name' }, through: :memberships

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :identities,
    allow_destroy: true,
    reject_if:     :blank_pseudonym?

  def blank_pseudonym?(identities_attributes)
    identities_attributes["pseudonym_id"].blank?
  end

  private :blank_pseudonym?

  accepts_nested_attributes_for :memberships,
    allow_destroy: true,
    reject_if:     :blank_member?

  def blank_member?(membership_attributes)
    membership_attributes["member_id"].blank?
  end

  private :blank_member?

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

  # Identities.

  def secondary?
    !primary?
  end

  def personae
    return pseudonyms.to_a if primary

    return [] unless parent = Identity.find_by(pseudonym_id: self.id).try(:creator)

    [parent, parent.pseudonyms].flatten.reject { |p| p == self }.sort_by(&:name)
  end

  # Memberships.

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

  # Works & Contributions.

  def media
    self.contributions.viewable.map(&:work).map(&:pluralized_human_medium).uniq.sort
  end

  def roles
    self.contributions.viewable.map(&:human_role).uniq.sort
  end

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
