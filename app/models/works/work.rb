# frozen_string_literal: true
# == Schema Information
#
# Table name: works
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  subtitle   :string
#  title      :string           not null
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_works_on_alpha  (alpha)
#  index_works_on_type   (type)
#

class Work < ApplicationRecord

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

  def self.grouped_options
    order(:type, :alpha).group_by{ |x| x.class.true_human_model_name }.to_a
  end

  def self.type_options
    load_descendants

    descendants.map { |d| [d.true_human_model_name, d.true_model_name.name] }.sort_by(&:last)
  end

  def self.valid_types
    load_descendants

    descendants.map { |d| d.true_model_name.name }.sort
  end

  def self.load_descendants
    # return if descendants.any?

    Dir["#{Rails.root}/app/models/works/*.rb"].each do |file|
      next if File.basename(file, ".rb") == File.basename(__FILE__, ".rb")

      require_dependency file
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager, -> { includes(
    :aspects, :milestones, :playlists, :reviews, :mixtapes,
    :credits, :creators, :contributions, :contributors
  ).references(:creators) }

  scope :for_admin, -> { eager }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :aspects

  has_many :milestones

  has_many :credits,       inverse_of: :work, dependent: :destroy
  has_many :contributions, inverse_of: :work, dependent: :destroy

  has_many :creators,     through: :credits,       source: :creator, class_name: "Creator"
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
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :type, presence: true
  validates :title, presence: true

  validates :credits, length: { minimum: 1 }

  validate_nested_uniqueness_of :credits,       uniq_attr: :creator_id
  validate_nested_uniqueness_of :contributions, uniq_attr: :creator_id, scope: [:role_id]

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def posts
    reviews.union(mixtapes)
  end

  def display_title(full: false)
    return unless persisted?

    parts = [title, subtitle]

    parts.unshift(credited_artists) if full

    parts.compact.join(": ")
  end

  def full_display_title
    display_title(full: true)
  end

  def display_aspects
    aspects.group_by(&:human_facet).to_a
  end

  def display_milestones
    milestones.sorted
  end

  def credited_artists(connector: " & ")
    return creators.alpha.to_a.map(&:name).join(connector) if persisted?

    # So we can correctly calculate memoized alpha value for review during
    # nested object creation.

    unsaved = credits.map { |c| c.creator.try(:name) }.compact

    unsaved.any? ? unsaved.sort.join(connector) : nil
  end

  def all_creators
    Creator.where(id: all_creator_ids)
  end

  def all_creator_ids
    (creators.ids + contributors.ids).uniq
  end

  def sluggable_parts
    [credited_artists(connector: " and "), title, subtitle]
  end

  def alpha_parts
    [credited_artists, title, subtitle]
  end
end
