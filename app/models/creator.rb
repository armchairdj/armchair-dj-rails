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

  scope :alphabetical, -> { order(Arel.sql("LOWER(creators.name)")) }
  scope :eager,        -> { all }
  scope :for_admin,    -> { eager }
  scope :for_site,     -> { viewable.includes(:posts).alphabetical }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :contributions, dependent: :destroy

  has_many :works, -> { where(contributions: {
    role: Contribution.roles["creator"] })
  }, through: :contributions, source: :work, class_name: "Work"

  has_many :contributed_works, -> { where.not(contributions: {
    role: Contribution.roles["creator"] })
  }, through: :contributions, source: :work, class_name: "Work"

  has_many :posts, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

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
