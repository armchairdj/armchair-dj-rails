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
  concerning :CreatorAssociations do
    included do
      include CreatorFilters

      with_options inverse_of: :work, dependent: :destroy do
        has_many :attributions
        has_many :contributions
        has_many :credits, -> { order(:position) }
      end

      with_options source: :creator, class_name: "Creator" do
        has_many :creators, -> { distinct }, through: :attributions

        has_many :contributors, -> { distinct }, through: :contributions

        has_many :makers, lambda {
          joins(:credits).select("creators.*, attributions.position").distinct
        }, through: :credits
      end

      with_options allow_destroy: true, reject_if: proc { |attrs| attrs["creator_id"].blank? } do
        accepts_nested_attributes_for :credits
        accepts_nested_attributes_for :contributions
      end

      validates :credits, length: { minimum: 1 }

      with_options uniq_attr: :creator_id do
        validates_nested_uniqueness_of :credits
        validates_nested_uniqueness_of :contributions, scope: [:role_id]
      end

      before_save :memoize_display_makers, prepend: true
    end

    def prepare_contributions
      10.times { contributions.build }
    end

    def prepare_credits
      3.times { credits.build }
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

  concerning :AspectsAssociation do
    included do
      has_and_belongs_to_many :aspects, -> { distinct }

      validate { only_available_aspects }
    end

    def display_aspects
      candidates = aspects.group_by(&:key).symbolize_keys

      self.class.available_aspects.each.with_object({}) do |available_key, memo|
        next unless (items = candidates[available_key])

        memo[items.first.human_key] = items
      end.to_a
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def only_available_aspects
      candidates = aspects.reject(&:marked_for_destruction?)
      disallowed = candidates.reject { |x| available_aspects.include?(x.key.to_sym) }

      errors.add(:aspects, :invalid) if disallowed.any?
    end
  end

  concerning :MilestonesAssociation do
    included do
      has_many :milestones, class_name: "Work::Milestone", dependent: :destroy

      accepts_nested_attributes_for :milestones,
        allow_destroy: true, reject_if: proc { |attrs| attrs["year"].blank? }

      validates_nested_uniqueness_of :milestones, uniq_attr: :activity

      validate { presence_of_released_milestone }
    end

    def display_milestones
      milestones.sorted
    end

    def prepare_milestones
      5.times { milestones.build }

      milestones.first.activity = :released if milestones.first.new_record?
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def presence_of_released_milestone
      return if milestones.reject(&:marked_for_destruction?).any?(&:released?)

      errors.add(:milestones, :blank)
    end
  end

  concerning :RelationshipAssociations do
    included do
      with_options class_name: "Work::Relationship", dependent: :destroy do
        has_many :source_relationships, foreign_key: :target_id, inverse_of: :target
        has_many :target_relationships, foreign_key: :source_id, inverse_of: :source
      end

      has_many :source_works, -> { order("works.title") },
        through: :source_relationships, source: :source

      has_many :target_works, -> { order("works.title") },
        through: :target_relationships, source: :target

      with_options allow_destroy: true do
        accepts_nested_attributes_for :source_relationships, reject_if: :reject_source?
        accepts_nested_attributes_for :target_relationships, reject_if: :reject_target?
      end

      with_options scope: [:connection] do
        validates_nested_uniqueness_of :target_relationships, uniq_attr: :target_id
        validates_nested_uniqueness_of :source_relationships, uniq_attr: :source_id
      end
    end

    def prepare_source_relationships
      5.times { source_relationships.build }
    end

    def prepare_target_relationships
      5.times { target_relationships.build }
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def reject_source?(attrs)
      attrs["source_id"].blank?
    end

    def reject_target?(attrs)
      attrs["target_id"].blank?
    end
  end

  concerning :PostAssociations do
    included do
      has_many :reviews, dependent: :nullify

      has_many :playlistings, class_name: "Playlist::Track",
        inverse_of: :work, foreign_key: :work_id, dependent: :nullify

      has_many :playlists, through: :playlistings
      has_many :mixtapes,  through: :playlists
    end

    def posts
      Post.where(id: post_ids)
    end

    def post_ids
      reviews.ids + mixtapes.ids
    end
  end

  concerning :Alphabetization do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [display_makers, title, subtitle]
    end
  end

  concerning :Editing do
    def available_relatives
      Work.where.not(id: id).grouped_by_medium
    end

    def prepare_for_editing
      return unless medium.present?

      prepare_credits
      prepare_contributions
      prepare_milestones
      prepare_source_relationships
      prepare_target_relationships
    end
  end

  concerning :GinsuIntegration do
    included do
      scope :for_list, -> {}
      scope :for_show, lambda {
        includes(
          :aspects, :milestones, :playlists, :reviews, :mixtapes,
          :credits, :makers, :contributions, :contributors
        )
      }
    end
  end

  concerning :ImageAttachment do
    included do
      include Imageable
    end
  end

  concerning :StiInheritance do
    included do
      self.inheritance_column = :medium

      validates :medium, presence: true

      class_attribute :available_aspects, default: []
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

  concerning :TitleAttribute do
    included do
      validates :title, presence: true
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
  end
end
