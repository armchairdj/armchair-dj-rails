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
    where(contributions: { role: Contribution.roles["creator"] })
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
    song:     100,
    album:    101,

    film:     200,
    tv_show:  201,

    book:     300,

    artwork:  400,

    software: 500
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
    self.all.to_a.sort_by { |c| c.title_with_creator }
  end

  def self.grouped_select_options_for_post
    {
      :"Songs"  => self.song.alphabetical,
      :"Albums" => self.album.alphabetical,
      :"TV"     => self.tv_show.alphabetical,
      :"Films"  => self.film.alphabetical,
      :"Books"  => self.book.alphabetical,
      :"Apps"   => self.software.alphabetical,
      :"Art"    => self.artwork.alphabetical,
    }.to_a
  end

  def self.admin_scopes
    {
      :"All"   => :all,
      :"Song"  => :song,
      :"Album" => :album,
      :"TV"    => :tv_show,
      :"Film"  => :film,
      :"Book"  => :book,
      :"App"   => :software,
      :"Art"   => :artwork,
    }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def prepare_contributions
    count_needed = self.class.max_contributions - self.contributions.length

    count_needed.times { self.contributions.build }
  end

  def title_with_creator
    "#{self.display_creator}: #{self.title}"
  end

  def display_creator
    self.creators.map(&:name).join(" & ")
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
