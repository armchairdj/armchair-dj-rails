class Work < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :contributions

  has_many :creators, -> {
    where(param => { role: WorkContribution.roles["credited_creator"] })
  }, through: :contributions

  has_many :contributors, through: :contributions,
    source: :creator, class_name: "Creator"

  has_many :posts, dependent: :destroy

  #############################################################################
  # NESTED ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :contributions,
    allow_destroy: true,
    reject_if:     :reject_blank_contributions

  #############################################################################
  # ENUMS.
  #############################################################################

  enum medium: {
    song:       0,
    album:      1,

    book:     100,

    film:     200,

    tv_show:  300
  }

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :alphabetical, -> { order(:title) }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :title, presence: true
  validates :medium, presence: true

  validate do
    validate_contributions
  end

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  def self.max_contributions
    10
  end

  def self.alphabetical_with_creator
    self.all.to_a.sort_by { |c| c.display_name_with_creator }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def display_name_with_creator
    "#{self.display_creator}: #{self.title}"
  end

  def display_creator
    self.creators.map(&:name).join(" & ")
  end

private

  def reject_blank_contributions(attributes)
    # work_contributions_atrributes
    #  work_contributions_atrributes
    attributes["creator_id"].blank?
  end

  def validate_contributions(param)
    return if self.contributions.reject(&:marked_for_destruction?).count > 0

    self.errors.add(:contributions, :missing)
  end
end
