# frozen_string_literal: true

class Post < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include AASM
  include Alphabetizable
  include Linkable
  include Sluggable
  include Summarizable

  #############################################################################
  # CLASS.
  #############################################################################

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

  scope :reverse_cron,    -> { order(published_at: :desc, publish_on: :desc, updated_at: :desc) }

  scope :eager,           -> { includes(:medium, :work, :creators, :author).references(:medium) }

  scope :for_admin,       -> { eager                        }
  scope :for_site,        -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :author, class_name: "User", foreign_key: :author_id

  has_and_belongs_to_many :tags

  belongs_to :work, optional: true

  has_one :medium,         through: :work
  has_many :creators,      through: :work
  has_many :contributors,  through: :work
  has_many :work_tags,     through: :work, class_name: "Tag", source: :tags

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :work, allow_destroy: false,
    reject_if: proc { |attrs| attrs["title"].blank? }

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

  validates :status, presence: true

  validates :body, presence: true, unless: :draft?

  validates :published_at, presence: true, if: :published?
  validates :publish_on,   presence: true, if: :scheduled?

  validates_date :publish_on, :after => lambda { Date.current }, allow_blank: true

  validate { author_present }

  def author_present
    if author.nil?
      self.errors.add(:base, :no_author)
    elsif !author.can_write?
      self.errors.add(:base, :invalid_author)
    end
  end

  private :author_present

  validate { work_or_title_present }

  def work_or_title_present
    if new_record?
      self.errors.add(:base,    :has_work_and_title ) if  work &&  title
      self.errors.add(:base,    :needs_work_or_title) if !work && !title
    elsif standalone?
      self.errors.add(:title,   :blank              ) if title.blank?
      self.errors.add(:work_id, :present            ) if work.present?
    elsif review?
      self.errors.add(:title,   :present            ) if title.present?
      self.errors.add(:work_id, :blank              ) if work.blank?
    end
  end

  private :work_or_title_present

  validate { only_uncategorized_tags }

  def only_uncategorized_tags
    return if tags.where.not(category_id: nil).empty?

    self.errors.add(:tag_ids, :categorized_tags)
  end

  private :only_uncategorized_tags

  #############################################################################
  # HOOKS.
  #############################################################################

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
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    if standalone?
      [ title ]
    else
      [
        ("reviews" if review?),
        work.sluggable_parts
      ].flatten
    end
  end

  def slug_locked?
    published?
  end

  def should_validate_slug_presence?
    !draft?
  end

  private :should_validate_slug_presence?

  #############################################################################
  # INSTANCE.
  #############################################################################

  def type(plural: false)
    base = review? ? "#{work.medium.name} Review" : "Post"

    plural ? base.pluralize : base
  end

  def viewable?
    published?
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
  end

  def alpha_parts
    standalone? ? [title] : [work.try(:alpha_parts)]
  end

  def all_tags
    Tag.where(id: [self.tag_ids, self.work.try(:tag_ids)].flatten.uniq)
  end

private

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

  def update_counts_for_descendents
    author.update_counts

    tags.each { |t| t.update_counts }

    return unless work.present?

    work.update_counts
    medium.update_counts
    contributors.each { |c| c.update_counts }
    creators.each     { |c| c.update_counts }
    work_tags.each    { |t| t.update_counts }
  end
end
