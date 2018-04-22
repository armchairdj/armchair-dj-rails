class Work < ApplicationRecord

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

  def self.max_contributions
    10
  end

  def self.alphabetical_by_creator
    self.all.to_a.sort_by { |c| c.title_with_creator }
  end

  def self.admin_filters
    {
      "Songs"       => :song,
      "Albums"      => :album,
      "Movies"      => :movie,
      "TV Shows"    => :tv_show,
      "Radio Shows" => :radio_show,
      "Podcasts"    => :podcast,
      "Books"       => :book,
      "Comics"      => :comic,
      "Newspapers"  => :newspaper,
      "Magazines"   => :magazine,
      "Artworks"    => :artwork,
      "Games"       => :game,
      "Software"    => :software,
      "Hardware"    => :hardware,
      "Products"    => :product,
    }
  end

  def self.grouped_options
    self.admin_filters.to_a.map do |arr|
      [arr.first, self.send(arr.last).eager.alphabetical_by_creator]
    end
  end

  def self.media_options
    media = Work.human_media_with_keys.map do |medium|
      medium[2] = { "data-work-grouping" => (medium[2] / 100).to_i }

      medium
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :alphabetical, -> { order("LOWER(works.title)") }
  scope :eager,        -> { includes(:creators).includes(contributions: :creator).where(contributions: { role: Contribution.roles["creator"] }) }
  scope :for_admin,    -> { eager }
  scope :for_site,     -> { eager.viewable.includes(:posts).alphabetical }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :contributions

  has_many :creators, -> {
    where(contributions: { role: Contribution.roles["creator"] })
  }, through: :contributions

  has_many :contributors, through: :contributions,
    source: :creator, class_name: "Creator"

  has_many :posts, dependent: :destroy

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :contributions,
    allow_destroy: true,
    reject_if:     :reject_blank_contributions

  enum medium: {
    song:        100,
    album:       101,

    movie:       200,
    tv_show:     220,
    radio_show:  240,
    podcast:     260,

    book:        300,
    comic:       310,
    newspaper:   350,
    magazine:    370,

    artwork:     400,

    game:        500,
    software:    501,
    hardware:    502,

    product:     600
  }

  enumable_attributes :medium

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true

  validates :title, presence: true

  validate { validate_contributions }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def prepare_contributions
    count_needed = self.class.max_contributions - self.contributions.length

    count_needed.times { self.contributions.build }
  end

  def title_with_creator
    return unless persisted?

    [display_creator, title].join(": ")
  end

  def display_creator(connector: " & ")
    return unless persisted?

    creators.alphabetical.to_a.map(&:name).join(connector)
  end

private

  def reject_blank_contributions(contribution_attributes)
    contribution_attributes["creator_id"].blank?
  end

  def validate_contributions
    available = self.contributions.reject(&:marked_for_destruction?)

    creators  = available.keep_if { |c| c.role == "creator" }

    return if creators.any?

    self.errors.add(:contributions, :missing)
  end
end
