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
      # Virtual attributes to trigger AASM transitions.
      #####################################################

      attribute :publishing,   :boolean, default: false
      attribute :unpublishing, :boolean, default: false
      attribute :scheduling,   :boolean, default: false
      attribute :unscheduling, :boolean, default: false

      after_save :unpublish!,   if: :unpublishing?
      after_save :unschedule!,  if: :unscheduling?
      after_save :publish!,     if: :publishing?
      after_save :schedule!,    if: :scheduling?

      after_save :handle_status_changes

      def handle_status_changes
        return unless changing_publication_status?

        case
        when publishing? && !published?
          self.publishing = false
          self.errors.add(:base, "Could not publish")
          # clear published_on from database?
        when scheduling? && !scheduled?
          self.scheduling = false
          self.errors.add(:base, "Could not schedule")
          # clear scheduled_at from database
        when unpublishing? && published?
          self.unpublishing = false
          self.errors.add(:base, "Could not unpublish")
        when unscheduling? && scheduled?
          sefl.unscheduling = false
          self.errors.add(:base, "Could not unschedule")
        end
      end

      #####################################################
      # Attributes.
      #####################################################

      enum status: {
        draft:      0,
        scheduled:  5,
        published: 10
      }

      enumable_attributes :status

      def unpublished?
        draft? || scheduled?
      end

      #####################################################
      # State Machine.
      #####################################################

      include AASM

      aasm( column: :status, enum: true,
            create_scopes: true,
            no_direct_assignment: true,
            whiny_persistence: false,
            whiny_transitions: false
      ) do
        state :draft, initial: true
        state :scheduled
        state :published

        event(:schedule) do
          transitions from: :draft, to: :scheduled, guards: [:persisted?]
        end

        event(:unschedule, before: :clear_publish_on) do
          transitions from: :scheduled, to: :draft
        end

        event(:publish, before: :set_published_at) do
          transitions from: [:draft, :scheduled], to: :published, guards: [:persisted?]
        end

        event(:unpublish, before: :clear_published_at) do
          transitions from: :published, to: :draft
        end
      end
    end

    #######################################################
    # Instance.
    #######################################################

    def changing_publication_status?
      unpublishing? || publishing? || unscheduling? || scheduling?
    end

  private

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

  concerning :Schedulable do
    included do
      scope :scheduled_for_publication, -> {
        scheduled.order(:publish_on).where("posts.publish_on <= ?", DateTime.now)
      }
    end

    class_methods do
      def publish_scheduled
        memo = { success: [], failure: [], all: scheduled_for_publication.to_a }

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

  has_and_belongs_to_many :tags, -> { order("tags.name").distinct }

  #############################################################################
  # VALIDATION.
  #############################################################################

  validates :type, presence: true

  validates :status, presence: true

  validates :summary, length: { in: 40..320 }, allow_blank: true

  validates :body,         presence: true, if: :requires_body?
  validates :published_at, presence: true, if: :requires_published_at?
  validates :publish_on,   presence: true, if: :requires_publish_on?

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
