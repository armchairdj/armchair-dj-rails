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
  # SCOPES.
  #############################################################################

  scope :alphabetical, -> { order("LOWER(works.title)") }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true

  validates :title, presence: true

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
      "Songs"       => self.song.alphabetical,
      "Albums"      => self.album.alphabetical,
      "Movies"      => self.movie.alphabetical,
      "TV"          => self.tv_show.alphabetical,
      "Radio"       => self.radio_show.alphabetical,
      "Podcast"     => self.podcast.alphabetical,
      "Books"       => self.book.alphabetical,
      "Comics"      => self.comic.alphabetical,
      "Newspapers"  => self.newspaper.alphabetical,
      "Magazines"   => self.magazine.alphabetical,
      "Art"         => self.artwork.alphabetical,
      "Game"        => self.game.alphabetical,
      "Software"    => self.software.alphabetical,
      "Hardware"    => self.hardware.alphabetical,
      "Product"     => self.product.alphabetical,
    }.to_a
  end

  def self.admin_scopes
    {
      "All"         => :all,
      "Song"        => :song,
      "Album"       => :album,
      "Movie"       => :movie,
      "TV"          => :tv_show,
      "Radio"       => :radio_show,
      "Pod"         => :podcast,
      "Book"        => :book,
      "Comic"       => :comic,
      "News"        => :newspaper,
      "Mag"         => :magazine,
      "Art"         => :artwork,
      "Game"        => :game,
      "Software"    => :software,
      "Hardware"    => :hardware,
      "Product"     => :product,
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
    self.creators.alphabetical.map(&:name).join(" & ")
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
