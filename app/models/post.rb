# frozen_string_literal: true

class Post < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include AASM
  include Sluggable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.admin_scopes
    {
      "Draft"     => :draft,
      "Scheduled" => :scheduled,
      "Published" => :published,
      "All"       => :all,
    }
  end

  def self.publish_scheduled
    ready = self.scheduled_ready

    memo = {
      total:   ready.length,
      success: [],
      failure: []
    }

    ready.each do |post|
      post.unschedule!

      if post.publish!
        memo[:success] << post
      else
        memo[:failure] << post
      end
    end

    memo
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :not_published,   -> { where.not(status: :published) }

  scope :scheduled_ready, -> { scheduled.where("posts.publish_on <= ?", DateTime.now) }

  scope :review,          -> { where.not(work_id: nil) }
  scope :standalone,      -> { where(    work_id: nil) }

  scope :reverse_cron,    -> { order(published_at: :desc) }

  scope :eager,           -> { includes(work: { credits: :creator }) }

  scope :for_admin,       -> { eager                   }
  scope :for_site,        -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :author, class_name: "User", foreign_key: :author_id, required: true

  belongs_to :work, required: false

  has_many :creators, through: :work

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :work,
    allow_destroy: true,
    reject_if:     :blank_work?

  enum status: {
    draft:      0,
    scheduled:  5,
    published: 10
  }

  enumable_attributes :status

  attr_accessor :current_work_id

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validate { validate_user           }
  validate { validate_work_and_title }

  validates :status, presence: true

  validates :body, presence: true, unless: :draft?

  validates :slug, presence: true, unless: :draft?
  validates :slug, uniqueness: true

  validates :published_at, presence: true, if: :published?
  validates :publish_on,   presence: true, if: :scheduled?

  validates_date :publish_on, :after => lambda { Date.current }, allow_blank: true

  #############################################################################
  # HOOKS.
  #############################################################################

  before_save :handle_slug

  #############################################################################
  # STATE MACHINE.
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

    event(:schedule,
      after: :update_counts_for_descendents
    ) do
      transitions from: :draft, to: :scheduled, guards: [:ready_to_publish?]
    end

    event(:unschedule,
      before: :clear_publish_on,
      after:  :update_counts_for_descendents
    ) do
      transitions from: :scheduled, to: :draft
    end

    event(:publish,
      before: :set_published_at,
      after:  :update_counts_for_descendents
    ) do
      transitions from: [:draft, :scheduled], to: :published, guards: [:ready_to_publish?]
    end

    event(:unpublish,
      before: :clear_published_at,
      after:  :update_counts_for_descendents
    ) do
      transitions from: :published, to: :draft
    end
  end

  def update_and_publish(params)
    return true if self.update(params) && self.publish!

    self.errors.add(:body, :blank_during_publish) unless body.present?

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

    self.errors.add(:body, :blank_during_publish) unless body.present?

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

  def type(plural: false)
    base = review? ? "#{work.human_medium} Review" : "Post"

    plural ? base.pluralize : base
  end

  def sluggable_type
    return nil unless review?

    type(plural: true)
  end

  def not_published?
    draft? || scheduled?
  end

  def standalone?
    if new_record?
      return title.present?
    else
      return title_was.present?
    end
  end

  def review?
    if new_record?
      return work.present?
    else
      return work_id_was.present?
    end
  end

  def prepare_work_for_editing(params = nil)
    return if standalone?

    if current_work_id = params.try(:[], "work_id") || work_id
      self.current_work_id = current_work_id.to_i
      self.work_id         = nil
    end

    build_work unless self.work.present?

    work.prepare_credits
    work.prepare_contributions
  end

private

  #############################################################################
  # NESTED ATTRIBUTES.
  #############################################################################

  def blank_work?(work_attributes)
    work_attributes["title"].blank?
  end

  #############################################################################
  # VALIDATION.
  #############################################################################

  def validate_user
    if author.nil?
      self.errors.add(:base, :no_author)
    elsif !author.writer? && !author.admin?
      self.errors.add(:base, :invalid_author)
    end
  end

  def validate_work_and_title
    ensure_work_or_title_for_new_record    ||
    ensure_only_title_for_saved_standalone ||
    ensure_only_work_for_saved_review
  end

  def ensure_work_or_title_for_new_record
    return false unless new_record?

    if work && title
      self.errors.add(:base, :has_work_and_title)
    elsif !work && !title
      self.errors.add(:base, :needs_work_or_title)
    end

    true
  end

  def ensure_only_title_for_saved_standalone
    return false unless persisted? && standalone?

    self.errors.add(:title,   :blank  ) if title.blank?
    self.errors.add(:work_id, :present) if work.present?

    true
  end

  def ensure_only_work_for_saved_review
    return false unless persisted? && review?

    self.errors.add(:title,   :present) if title.present?
    self.errors.add(:work_id, :blank  ) if work.blank?

    true
  end

  #############################################################################
  # SLUG.
  #############################################################################

  def handle_slug
    return if slug_published?
    return if slug_already_dirty?
    return if slug_newly_dirty?

    self.dirty_slug = false

    slugify(:slug, sluggable_parts)
  end

  def slug_published?
    return false unless published?

    self.errors.add(:slug, :locked) if slug_changed?

    true
  end

  def slug_already_dirty?
    dirty_slug? && !slug_changed?
  end

  def slug_newly_dirty?
    return false unless slug_changed? && !slug.blank?

    self.dirty_slug = true

    slugify(:slug, slug)

    true
  end

  def sluggable_parts
    if title.present?
      [ title ]
    elsif work.present?
      [
        sluggable_type,
        work.display_creators(connector: " and "),
        work.title,
        work.subtitle
      ].compact
    end
  end

  #############################################################################
  # PUBLISHING.
  #############################################################################

  def ready_to_publish?
    persisted? && not_published? && valid? && body.present? && slug.present?
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

  #############################################################################
  # MEMOIZATION.
  #############################################################################

  def update_counts_for_descendents
    return unless work.present?

    work.update_counts
    work.creators.each { |c| c.update_counts }
  end
end
