# frozen_string_literal: true

class Work < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_CREDITS       =  5.freeze
  MAX_CONTRIBUTIONS = 20.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Summarizable
  include Viewable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.alphabetical_by_creator
    self.all.to_a.sort_by { |w| w.full_display_title }
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

  scope :alphabetical, -> { order(Arel.sql("LOWER(works.title)")) }
  scope :eager,        -> { includes(:creators, :contributors) }
  scope :for_admin,    -> { eager }
  scope :for_site,     -> { eager.viewable.includes(:posts).alphabetical }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :credits, dependent: :destroy
  has_many :creators, through: :credits

  has_many :contributions, dependent: :destroy
  has_many :contributors, through: :contributions, source: :creator, class_name: "Creator"

  has_many :posts, dependent: :destroy

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  # Credits.

  accepts_nested_attributes_for :credits,
    allow_destroy: true,
    reject_if:     proc { |attrs| attrs["creator_id"].blank? }

  def prepare_credits
    count_needed = MAX_CREDITS - self.credits.length

    count_needed.times { self.credits.build }
  end

  # Contributions.

  accepts_nested_attributes_for :contributions,
    allow_destroy: true,
    reject_if:     proc { |attrs| attrs["creator_id"].blank? }

  def prepare_contributions
    count_needed = MAX_CONTRIBUTIONS - self.contributions.length

    count_needed.times { self.contributions.build }
  end

  # def contributions_attributes=(attributes)
  #   puts "contributions_attributes="
  #
  #   uniques = (attributes.values.map do |item_attributes|
  #     attrs = item_attributes.stringify_keys
  #
  #     { "creator_id" => attrs["creator_id"].to_s, "role" => attrs["role"].to_s }
  #   end).compact.map.uniq
  #
  #   puts ">>uniques", uniques
  #
  #   deduped = uniques.each.with_index(0).inject({}) do |memo, (item, index)|
  #     memo[index.to_s] = item; memo
  #   end
  #
  #   puts ">>deduped", deduped
  #
  #   super(deduped)
  # end

  # Medium.

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

  validate { at_least_one_credit }

  def at_least_one_credit
    return if self.credits.reject(&:marked_for_destruction?).any?

    self.errors.add(:credits, :missing)
  end

  private :at_least_one_credit

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def display_title
    return unless persisted?

    [title, subtitle].compact.join(": ")
  end

  def full_display_title
    return unless persisted?

    [display_creators, title, subtitle].compact.join(": ")
  end

  def display_creators(connector: " & ")
    return unless persisted?

    creators.alphabetical.to_a.map(&:name).join(connector)
  end
end
