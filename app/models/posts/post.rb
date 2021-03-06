# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  alpha        :string
#  body         :text
#  publish_on   :datetime
#  published_at :datetime
#  slug         :string
#  status       :integer          default("draft"), not null
#  summary      :text
#  title        :string
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint(8)
#  playlist_id  :bigint(8)
#  work_id      :bigint(8)
#
# Indexes
#
#  index_posts_on_alpha        (alpha)
#  index_posts_on_author_id    (author_id)
#  index_posts_on_playlist_id  (playlist_id)
#  index_posts_on_slug         (slug) UNIQUE
#  index_posts_on_status       (status)
#  index_posts_on_type         (type)
#  index_posts_on_work_id      (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (playlist_id => playlists.id)
#  fk_rails_...  (work_id => works.id)
#

class Post < ApplicationRecord
  concerning :AuthorAssociation do
    included do
      include Authorable
    end

    class_methods do
      def for_cms_user(user)
        return all                       if user&.can_edit?
        return where(author_id: user.id) if user&.can_write?

        none
      end
    end
  end

  concerning :ContentAttributes do
    included do
      with_options presence: true, if: :requires_content? do
        validates :body
        validates :summary
      end

      validates :summary, length: { in: 40..320 }, allow_blank: true
    end

    def formatted_body
      return unless body.present?

      markdown_renderer.render(body).html_safe
    end

    private

    def requires_content?
      published? || publishing? || scheduled? || scheduling?
    end

    def markdown_renderer
      @markdown_renderer ||= Redcarpet::Markdown.new(PostRenderer)
    end
  end

  concerning :GinsuIntegration do
    included do
      scope :for_list, -> { includes(:author).references(:author) }
      scope :for_show, -> { includes(:links, :author, :tags) }
    end
  end

  concerning :LinksAssociation do
    included do
      include Linkable
    end
  end

  concerning :PublicSite do
    RELATED_POST_COUNT = 3

    included do
      scope :reverse_cron, -> { order(published_at: :desc, publish_on: :desc, updated_at: :desc) }

      scope :for_public, -> { published.reverse_cron }

      scope :additional_posts, lambda { |post, limit|
        for_public.distinct.where.not(id: post.id).limit(limit)
      }
    end

    def related_posts(limit = RELATED_POST_COUNT)
      self.class.additional_posts(self, limit)
    end
  end

  concerning :SlugAttribute do
    included do
      include Sluggable
    end
  end

  concerning :StiInheritance do
    included do
      validates :type, presence: true
    end
  end

  concerning :TagAssociation do
    included do
      has_and_belongs_to_many :tags, -> { order("tags.name") }

      scope :by_tag, ->(*tags) { by_association(tags, :tags) }
    end
  end

  concerning :StatusAttribute do
    included do
      enum status: {
        draft:     0,
        scheduled: 5,
        published: 10
      }

      improve_enum :status

      validates :status, presence: true

      scope :unpublished, -> { where.not(status: :published) }
    end

    def unpublished?
      draft? || scheduled?
    end
  end

  concerning :StateMachine do
    included do
      include AASM

      aasm(
        column:               :status,
        enum:                 true,
        create_scopes:        true,
        no_direct_assignment: true,
        whiny_persistence:    false,
        whiny_transitions:    false
      ) do
        state :draft, initial: true
        state :scheduled
        state :published, before_enter: :clear_publish_on

        event(:schedule) do
          transitions from: :draft, to: :scheduled
        end

        event(:unschedule, before: :clear_publish_on) do
          transitions from: :scheduled, to: :draft
        end

        event(:publish, before: :set_published_at) do
          transitions from: [:draft, :scheduled], to: :published
        end

        event(:unpublish, before: :clear_published_at) do
          transitions from: :published, to: :draft
        end
      end
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def set_published_at
      self.published_at = Time.zone.now
    end

    def clear_published_at
      self.published_at = nil
    end

    def clear_publish_on
      self.publish_on = nil
    end
  end

  concerning :StateMachineValidation do
    included do
      validates :published_at, presence: true, if:     :requires_published_at?
      validates :published_at, absence:  true, unless: :requires_published_at?

      validates :publish_on, presence: true, if:     :requires_publish_on?
      validates :publish_on, absence:  true, unless: :requires_publish_on?

      validates_date :publish_on, after: -> { Date.current }, allow_blank: true
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def requires_publish_on?
      scheduled? || scheduling?
    end

    def requires_published_at?
      published? || publishing?
    end
  end

  concerning :StateMachineTransitions do
    included do
      attribute :publishing,   :boolean, default: false
      attribute :unpublishing, :boolean, default: false
      attribute :scheduling,   :boolean, default: false
      attribute :unscheduling, :boolean, default: false

      before_validation :unpublish,  if: :unpublishing?
      before_validation :unschedule, if: :unscheduling?
      before_validation :publish,    if: :publishing?
      before_validation :schedule,   if: :scheduling?

      after_save :clear_transition_flags

      scope :scheduled_and_due, lambda {
        scheduled.order(:publish_on).where("posts.publish_on <= ?", Time.zone.now)
      }
    end

    class_methods do
      def publish_scheduled
        results = { all: scheduled_and_due.to_a, success: [], failure: [] }

        results[:all].each do |post|
          post.unschedule!

          key = post.publish! ? :success : :failure

          results[key] << post
        end

        results
      end
    end

    def changing_publication_status?
      unpublishing? || publishing? || unscheduling? || scheduling?
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def clear_transition_flags
      self.publishing   = false
      self.unpublishing = false
      self.scheduling   = false
      self.unscheduling = false
    end
  end

  concerning :StateMachineTransitionFailures do
    included do
      after_validation :handle_failed_transition
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def handle_failed_transition
      return unless errors.any? && changing_publication_status?

      reverse_failed_transition

      clear_transition_flags
    end

    def reverse_failed_transition
      return handle_failed_publish if publishing?
      return handle_failed_unpublish if unpublishing?
      return handle_failed_schedule if scheduling?
      return handle_failed_unschedule if unscheduling?
    end

    def handle_failed_publish
      unpublish
      errors.add(:base, :failed_to_publish)
    end

    def handle_failed_unpublish
      publish
      errors.add(:base, :failed_to_unpublish)

      self.published_at = published_at_was
    end

    def handle_failed_schedule
      temp = publish_on

      unschedule
      errors.add(:base, :failed_to_schedule)

      self.publish_on = temp
    end

    def handle_failed_unschedule
      schedule
      errors.add(:base, :failed_to_unschedule)

      self.publish_on = publish_on_was
    end
  end
end
