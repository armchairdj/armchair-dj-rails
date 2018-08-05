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

  #############################################################################
  # CONCERNING: STI subclass contract.
  #############################################################################

  concerning :Subclassable do
    included do
      self.inheritance_column = :medium

      validates :medium, presence: true
    end

    class_methods do
      def grouped_by_medium
        order(:medium, :alpha).group_by(&:display_medium).to_a
      end

      def media
        load_descendants

        classes = descendants.reject { |x| x == Medium }

        classes.map { |x| [x.display_medium, x.true_model_name.name] }.sort_by(&:last)
      end

      def valid_media
        media.map(&:last)
      end

      def load_descendants
        return unless Rails.env.development? || Rails.env.test?

        Dir["#{Rails.root}/app/models/works/*.rb"].each do |file|
          next if File.basename(file, ".rb") == File.basename(__FILE__, ".rb")

          require_dependency file
        end
      end
    end
  end

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  def alpha_parts
    [display_makers, title, subtitle]
  end

  #############################################################################
  # CONCERNING: Title.
  #############################################################################

  validates :title, presence: true

  def display_title(full: false)
    return unless persisted?

    parts = [title, subtitle]

    parts.unshift(display_makers) if full

    parts.compact.join(": ")
  end

  def full_display_title
    display_title(full: true)
  end

  #############################################################################
  # CONCERNING: Aspects.
  #############################################################################

  concerning :Aspects do
    included do
      class_attribute :available_facets, default: []

      has_and_belongs_to_many :aspects, -> { distinct }

      validate { only_available_aspects }
    end

    def display_facets
      aspects.group_by(&:human_facet).to_a
    end

  private

    def only_available_aspects
      candidates = aspects.reject(&:marked_for_destruction?)
      disallowed = candidates.reject { |x| available_facets.include?(x.facet.to_sym) }

      self.errors.add(:aspects, :invalid) if disallowed.any?
    end
  end

  #############################################################################
  # CONCERNING: Relationships to other works.
  #############################################################################

  has_many :source_relationships, class_name: "Work::Relationship",
    foreign_key: :target_id, inverse_of: :target, dependent: :destroy

  has_many :source_works, -> { order("works.title") },
    through: :source_relationships, source: :source

  has_many :target_relationships, class_name: "Work::Relationship",
    foreign_key: :source_id, inverse_of: :source, dependent: :destroy

  has_many :target_works, -> { order("works.title") },
    through: :target_relationships, source: :target

  concerning :NestedSourceRelationships do
    MAX_SOURCE_RELATIONSHIPS_AT_ONCE = 5.freeze

    included do
      accepts_nested_attributes_for(:source_relationships,
        allow_destroy: true, reject_if: :invalid_source_attrs?
      )
    end

    def prepare_source_relationships
      MAX_SOURCE_RELATIONSHIPS_AT_ONCE.times { self.source_relationships.build }
    end

  private

    def invalid_source_attrs?(attrs)
      attrs["source_id"].blank?
    end
  end

  concerning :NestedTargetRelationships do
    MAX_TARGET_RELATIONSHIPS_AT_ONCE = 5.freeze

    included do
      accepts_nested_attributes_for(:target_relationships,
        allow_destroy: true, reject_if: :invalid_target_attrs?
      )
    end

    def prepare_target_relationships
      MAX_TARGET_RELATIONSHIPS_AT_ONCE.times { self.target_relationships.build }
    end

  private

    def invalid_target_attrs?(attrs)
      attrs["target_id"].blank?
    end
  end

  #############################################################################
  # CONCERNING: Milestones.
  #############################################################################

  has_many :milestones, class_name: "Work::Milestone", dependent: :destroy

  concerning :Milestones do
    MAX_MILESTONES_AT_ONCE = 5.freeze

    included do
      accepts_nested_attributes_for(:milestones, allow_destroy: true,
        reject_if: proc { |attrs| attrs["year"].blank? }
      )

      validates_nested_uniqueness_of :milestones, uniq_attr: :activity

      validate { has_released_milestone }
    end

    def display_milestones
      milestones.sorted
    end

    def prepare_milestones
      MAX_MILESTONES_AT_ONCE.times { self.milestones.build }

      if milestones.first.new_record?
        milestones.first.activity = :released
      end
    end

  private

    def has_released_milestone
      return if milestones.reject(&:marked_for_destruction?).any?(&:released?)

      self.errors.add(:milestones, :blank)
    end
  end

  #############################################################################
  # CONCERNING: Attributions.
  #############################################################################

  has_many :attributions, inverse_of: :work, dependent: :destroy

  def creators
    Creator.where(id: creator_ids)
  end

  def creator_ids
    attributions.map(&:creator_id).uniq
  end

  #############################################################################
  # CONCERNING: Credits.
  #############################################################################

  has_many :credits, -> { order(:position) }, inverse_of: :work, dependent: :destroy

  has_many :makers, through: :credits, source: :creator, class_name: "Creator"

  concerning :NestedCredits do
    MAX_CREDITS_AT_ONCE = 3.freeze

    included do
      accepts_nested_attributes_for(:credits, allow_destroy: true,
        reject_if: proc { |attrs| attrs["creator_id"].blank? }
      )

      validates :credits, length: { minimum: 1 }

      validates_nested_uniqueness_of :credits, uniq_attr: :creator_id

      before_save :memoize_display_makers, prepend: true
    end

    def prepare_credits
      MAX_CREDITS_AT_ONCE.times { self.credits.build }
    end

  private

    def memoize_display_makers
      self.display_makers = collect_makers
    end

    def collect_makers
      names = credits.reject(&:marked_for_destruction?).map { |x| x.creator.name }

      names.empty? ? nil : names.join(" & ")
    end
  end

  #############################################################################
  # CONCERNING: Contributions.
  #############################################################################

  has_many :contributions, inverse_of: :work, dependent: :destroy

  has_many :contributors, through: :contributions, source: :creator, class_name: "Creator"

  concerning :NestedContributions do
    MAX_CONTRIBUTIONS_AT_ONCE = 10.freeze

    included do
      accepts_nested_attributes_for(:contributions, allow_destroy: true,
        reject_if: proc { |attrs| attrs["creator_id"].blank? }
      )

      validates_nested_uniqueness_of :contributions, uniq_attr: :creator_id, scope: [:role_id]
    end

    def prepare_contributions
      MAX_CONTRIBUTIONS_AT_ONCE.times { self.contributions.build }
    end
  end

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  has_many :reviews, dependent: :nullify

  has_many :playlistings, class_name: "Playlist::Track",
    inverse_of: :work, foreign_key: :work_id, dependent: :nullify

  has_many :playlists, through: :playlistings
  has_many :mixtapes,  through: :playlists

  def posts
    Post.where(id: post_ids)
  end

  def post_ids
    reviews.ids + mixtapes.ids
  end

  #############################################################################
  # CONCERNING: Editing.
  #############################################################################

  def prepare_for_editing
    return unless medium.present?

    prepare_credits
    prepare_contributions
    prepare_milestones
    prepare_source_relationships
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list, -> { }
  scope :for_show, -> { includes(
    :aspects, :milestones, :playlists, :reviews, :mixtapes,
    :credits, :makers, :contributions, :contributors
  ) }
end
