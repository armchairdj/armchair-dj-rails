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

  # Participations.

  has_many :participations
  has_many :participants, through: :participations

  has_many :members, -> { where(participations: {
    role: Participation.relationships["has_member"]
  })}, through: :participations, source: :participant, class_name: "Creator"

  has_many :memberships, -> { where(participations: {
    role: Participation.relationships["member_of"]
  })}, through: :participations, source: :participant, class_name: "Creator"

  has_many :names, -> { where(participations: {
    role: Participation.relationships["has_name"]
  })}, through: :participations, source: :participant, class_name: "Creator"

  has_many :namings, -> { where(participations: {
    role: Participation.relationships["named"]
  })}, through: :participations, source: :participant, class_name: "Creator"

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :participations,
    allow_destroy: true,
    reject_if:     :blank_participation?

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

  def aliased
    self.participants.alias
  end

  def memberships
    self.participants.member_of
  end

  def alternate_identities
  
  end

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

private

  def blank_participation?(participation_attributes)
    participation_attributes["participant_id"].blank?
  end
end
