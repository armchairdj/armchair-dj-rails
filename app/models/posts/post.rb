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

  include AASM
  include Alphabetizable
  include Authorable
  include Linkable
  include Sluggable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.publish_scheduled
    ready = self.scheduled_for_publication

    memo = {
      all:     ready.to_a,
      success: [],
      failure: []
    }

    ready.each do |instance|
      instance.unschedule!

      if instance.publish!
        memo[:success] << instance
      else
        memo[:failure] << instance
      end
    end

    memo
  end

  def self.eager
    includes(:links, :author, :tags).references(:author)
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :scheduled_for_publication, -> {
    scheduled.order(:publish_on).where("posts.publish_on <= ?", DateTime.now)
  }

  scope :unpublished,  -> { where.not(status: :published) }
  scope :reverse_cron, -> { order(published_at: :desc, publish_on: :desc, updated_at: :desc) }

  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.published.reverse_cron }

  # TODO BJD create scopes to list posts by creator, work, year, tag or aspect
  # scope :for_creator
  # scope :for_year
  # scope :for_work
  # scope :for_tag
  # scope :for_aspect

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :tags, -> { distinct }

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum status: {
    draft:      0,
    scheduled:  5,
    published: 10
  }

  enumable_attributes :status

  #############################################################################
  # VALIDATION.
  #############################################################################

  validates :type, presence: true

  validates :status, presence: true

  validates :summary, length: { in: 40..320 }, allow_blank: true

  validates :body,         presence: true, unless: :draft?
  validates :published_at, presence: true, if: :published?
  validates :publish_on,   presence: true, if: :scheduled?

  validates_date :publish_on, :after => lambda { Date.current }, allow_blank: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # AASM LIFECYCLE.
  #############################################################################

  aasm(
    column:                   :status,
    create_scopes:            true,
    enum:                     true,
    no_direct_assignment:     true,
    whiny_persistence:        false,
    whiny_transitions:        false
  ) do
    state :draft, initial: true
    state :scheduled
    state :published

    event(:schedule) do
      transitions from: :draft, to: :scheduled, guards: [:ready_to_publish?]
    end

    event(:unschedule,
      before: :clear_publish_on
    ) do
      transitions from: :scheduled, to: :draft
    end

    event(:publish,
      before: :set_published_at
    ) do
      transitions from: [:draft, :scheduled], to: :published, guards: [:ready_to_publish?]
    end

    event(:unpublish,
      before: :clear_published_at
    ) do
      transitions from: :published, to: :draft
    end
  end

  #############################################################################
  # AASM TRANSITIONS.
  #############################################################################

  def update_and_publish(params)
    return true if self.update(params) && self.publish!

    self.errors.add(:body, :blank) unless body.present?

    return false
  end

  def update_and_unpublish(params)
    # Transition and reload to trigger validation changes before update.
    unpublished = self.unpublish!
    updated     = self.reload.update(params)

    unpublished && updated
  end

  def update_and_schedule(params)
    return true if self.update(params) && self.schedule!

    clear_publish_on_from_database

    self.errors.add(:body, :blank) unless body.present?

    return false
  end

  def update_and_unschedule(params)
    # Transition and reload to trigger validation changes before update.
    unscheduled = self.unschedule!
    updated     = self.reload.update(params)

    unscheduled && updated
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def unpublished?
    draft? || scheduled?
  end

  def formatted_body
    return unless body.present?

    renderer.render(body).html_safe
  end

private

  def renderer
    @renderer ||= Redcarpet::Markdown.new(PostRender)
  end

  #############################################################################
  # AASM CALLBACKS.
  #############################################################################

  def ready_to_publish?
    persisted? && unpublished? && valid? && body.present?
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

  def clear_publish_on_from_database
    return unless temp = self.publish_on

    self.update_column(:publish_on, nil)

    self.publish_on = temp
  end
end
