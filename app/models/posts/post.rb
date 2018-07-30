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

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Authorable
  include Linkable
  include Sluggable

  #############################################################################
  # CONCERNING: Publishing.
  #############################################################################

  concerning :Publishable do
    included do

      #####################################################
      # Attributes.
      #####################################################

      enum status: {
        draft:      0,
        scheduled:  5,
        published: 10
      }

      enumable_attributes :status

      #####################################################
      # Virtual attributes to trigger AASM transitions.
      #####################################################

      attribute :publishing,   :boolean, default: false
      attribute :unpublishing, :boolean, default: false
      attribute :scheduling,   :boolean, default: false
      attribute :unscheduling, :boolean, default: false

      #####################################################
      # Hooks.
      #####################################################

      before_validation :unpublish,  if: :unpublishing?
      before_validation :unschedule, if: :unscheduling?
      before_validation :publish,    if: :publishing?
      before_validation :schedule,   if: :scheduling?

      after_validation :handle_failed_transition

      after_save :clear_transition_flags

      #####################################################
      # State Machine.
      #####################################################

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

    #######################################################
    # Instance.
    #######################################################

    def unpublished?
      draft? || scheduled?
    end

    def changing_publication_status?
      unpublishing? || publishing? || unscheduling? || scheduling?
    end

  private

    def handle_failed_transition
      return unless self.errors.any? && changing_publication_status?

      case
      when publishing?;   handle_failed_publish
      when unpublishing?; handle_failed_unpublish
      when scheduling?;   handle_failed_schedule
      when unscheduling?; handle_failed_unschedule
      end

      clear_transition_flags
    end

    def handle_failed_publish
      self.unpublish
      self.errors.add(:base, :failed_to_publish)
    end

    def handle_failed_unpublish
      self.publish
      self.errors.add(:base, :failed_to_unpublish)

      self.published_at = self.published_at_was
    end

    def handle_failed_schedule
      temp = self.publish_on

      self.unschedule
      self.errors.add(:base, :failed_to_schedule)

      self.publish_on = temp
    end

    def handle_failed_unschedule
      self.schedule
      self.errors.add(:base, :failed_to_unschedule)

      self.publish_on = self.publish_on_was
    end

    def clear_transition_flags
      self.publishing   = false
      self.unpublishing = false
      self.scheduling   = false
      self.unscheduling = false
    end

    def set_published_at
      self.published_at = DateTime.now
    end

    def clear_published_at
      self.published_at = nil
    end

    def clear_publish_on
      self.publish_on = nil
    end
  end

  #############################################################################
  # Concerning: Scheduled publication rake task.
  #############################################################################

  concerning :Scheduled do
    included do
      scope :scheduled_and_due, -> {
        scheduled.order(:publish_on).where("posts.publish_on <= ?", DateTime.now)
      }
    end

    class_methods do
      def publish_scheduled
        memo = { success: [], failure: [], all: scheduled_and_due.to_a }

        memo[:all].each do |item|
          item.unschedule!

          if item.publish!
            memo[:success] << item
          else
            memo[:failure] << item
          end
        end

        memo
      end
    end
  end

  #############################################################################
  # CONCERNING: Markdown.
  #############################################################################

  concerning :Markdownable do
    def formatted_body
      return unless body.present?

      renderer.render(body).html_safe
    end

  private

    def renderer
      @renderer ||= Redcarpet::Markdown.new(PostRenderer)
    end
  end

  #############################################################################
  # CLASS
  #############################################################################

  def self.for_list
    includes(:author).references(:author)
  end

  def self.for_show
    includes(:links, :author, :tags)
  end

  def self.for_cms_user(user)
    return self.none unless user && user.can_access_cms?
    return self.all  if user.can_edit?

    where(author_id: user.id)
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_public,  -> { published.reverse_cron }

  scope :reverse_cron, -> { order(published_at: :desc, publish_on: :desc, updated_at: :desc) }

  scope :unpublished, -> { where.not(status: :published) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :tags, -> { order("tags.name") }

  #############################################################################
  # VALIDATION.
  #############################################################################

  validates :type, presence: true

  validates :status, presence: true

  validates :summary, length: { in: 40..320 }, allow_blank: true

  validates :body, presence: true, if: :requires_body?

  validates :published_at, presence: true, if:     :requires_published_at?
  validates :published_at, absence:  true, unless: :requires_published_at?

  validates :publish_on, presence: true, if:     :requires_publish_on?
  validates :publish_on, absence:  true, unless: :requires_publish_on?

  validates_date :publish_on, after: lambda { Date.current }, allow_blank: true

private

  def requires_body?
    published? || publishing? || scheduled? || scheduling?
  end

  def requires_publish_on?
    scheduled? || scheduling?
  end

  def requires_published_at?
    published? || publishing?
  end

  def should_reset_slug_and_history?
    unpublished?
  end
end
