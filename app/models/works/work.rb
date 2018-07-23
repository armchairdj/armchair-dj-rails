# frozen_string_literal: true
# == Schema Information
#
# Table name: works
#
#  id             :bigint(8)        not null, primary key
#  alpha          :string
#  display_makers :string
#  medium         :string
#  subtitle       :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_works_on_alpha   (alpha)
#  index_works_on_medium  (medium)
#

class Work < ApplicationRecord

  self.inheritance_column = :medium

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_MILESTONES_AT_ONCE    =  5.freeze
  MAX_CREDITS_AT_ONCE       =  3.freeze
  MAX_CONTRIBUTIONS_AT_ONCE = 10.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.grouped_by_medium
    order(:medium, :alpha).group_by(&:display_medium).to_a
  end

  def self.media
    load_descendants

    classes = descendants.reject { |x| x == Medium }

    classes.map { |x| [x.display_medium, x.true_model_name.name] }.sort_by(&:last)
  end

  def self.valid_media
    media.map(&:last)
  end

  def self.load_descendants
    return unless Rails.env.development? || Rails.env.test?

    Dir["#{Rails.root}/app/models/works/*.rb"].each do |file|
      next if File.basename(file, ".rb") == File.basename(__FILE__, ".rb")

      require_dependency file
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list, -> { }
  scope :for_show, -> { includes(
    :aspects, :milestones, :playlists, :reviews, :mixtapes,
    :credits, :makers, :contributions, :contributors
  ) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :aspects, -> { distinct }

  has_many :milestones, dependent: :destroy

  has_many :credits, -> { order(:position) }, inverse_of: :work, dependent: :destroy
  has_many :contributions,                    inverse_of: :work, dependent: :destroy

  has_many :makers,       through: :credits,       source: :creator, class_name: "Creator"
  has_many :contributors, through: :contributions, source: :creator, class_name: "Creator"

  has_many :reviews, dependent: :destroy

  has_many :playlistings, inverse_of: :work, dependent: :destroy
  has_many :playlists, through: :playlistings
  has_many :mixtapes,  through: :playlists

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  # Credits.

  accepts_nested_attributes_for :credits, allow_destroy: true,
    reject_if: proc { |attrs| attrs["creator_id"].blank? }

  def prepare_credits
    MAX_CREDITS_AT_ONCE.times { self.credits.build }
  end

  # Contributions.

  accepts_nested_attributes_for :contributions, allow_destroy: true,
    reject_if: proc { |attrs| attrs["creator_id"].blank? }

  def prepare_contributions
    MAX_CONTRIBUTIONS_AT_ONCE.times { self.contributions.build }
  end

  # Milestones.

  accepts_nested_attributes_for :milestones, allow_destroy: true,
    reject_if: proc { |attrs| attrs["year"].blank? }

  def prepare_milestones
    MAX_MILESTONES_AT_ONCE.times { self.milestones.build }

    if milestones.first.new_record?
      milestones.first.activity = :released
    end
  end

  # All.

  def prepare_for_editing
    return unless medium.present?

    prepare_credits
    prepare_contributions
    prepare_milestones
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true
  validates :title, presence: true

  validates :credits, length: { minimum: 1 }

  validate_nested_uniqueness_of :credits,       uniq_attr: :creator_id
  validate_nested_uniqueness_of :contributions, uniq_attr: :creator_id, scope: [:role_id]
  validate_nested_uniqueness_of :milestones,    uniq_attr: :activity

  validate { has_released_milestone }

  def has_released_milestone
    return if milestones.reject(&:marked_for_destruction?).any?(&:released?)

    self.errors.add(:milestones, :blank)
  end

  private :has_released_milestone

  #############################################################################
  # HOOKS.
  #############################################################################

  before_save :memoize_display_makers, prepend: true

  def memoize_display_makers
    self.display_makers = collect_makers
  end

  private :memoize_display_makers

  #############################################################################
  # INSTANCE.
  #############################################################################

  def posts
    Post.where(id: post_ids)
  end

  def post_ids
    reviews.ids + mixtapes.ids
  end

  def creators
    Creator.where(id: creator_ids)
  end

  def creator_ids
    (makers.ids + contributors.ids).uniq
  end

  def display_title(full: false)
    return unless persisted?

    parts = [title, subtitle]

    parts.unshift(display_makers) if full

    parts.compact.join(": ")
  end

  def full_display_title
    display_title(full: true)
  end

  def display_facets
    aspects.group_by(&:human_facet).to_a
  end

  def display_milestones
    milestones.sorted
  end

  def collect_makers
    arr = credits.reject(&:marked_for_destruction?).map { |x| x.creator.name }

    arr.empty? ? nil : arr.join(" & ")
  end

  def sluggable_parts
    [display_medium.pluralize, display_makers, title, subtitle]
  end

  def alpha_parts
    [display_makers, title, subtitle]
  end
end
