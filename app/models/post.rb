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
  include Authorable
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

  scope :mixtape,         -> { where.not(playlist_id: nil) }
  scope :review,          -> { where.not(work_id:     nil) }
  scope :standalone,      -> { where.not(title:       nil) }

  scope :reverse_cron,    -> { order(published_at: :desc, publish_on: :desc, updated_at: :desc) }

  scope :eager,           -> { includes(:medium, :work, :creators, :author).references(:medium) }

  scope :for_admin,       -> { eager                        }
  scope :for_site,        -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :tags

  belongs_to :work,     optional: true
  belongs_to :playlist, optional: true

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

  validate { has_title_or_postable }

  def has_title_or_postable
    if new_record?
      self.errors.add(:base,        :has_title_and_postable ) if     (title && (work || playlist))
      self.errors.add(:base,        :needs_title_or_postable) unless (title || work || playlist)
    elsif standalone?
      self.errors.add(:title,       :blank                  ) if title.blank?
      self.errors.add(:work_id,     :present                ) if work.present?
    elsif review?
      self.errors.add(:work_id,     :blank                  ) if work.blank?
      self.errors.add(:title,       :present                ) if title.present?
    elsif mixtape?
      self.errors.add(:playlist_id, :blank                  ) if playlist.blank?
      self.errors.add(:title,       :present                ) if title.present?
    end
  end

  private :has_title_or_postable

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
  # AASM.
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
    elsif review?
      [ "reviews", work.sluggable_parts ]
    elsif mixtape?
      [ "mixes", playlist.sluggable_parts ]
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
  # INSTANCE: TYPE METHODS.
  #############################################################################

  def standalone?
    if new_record?
      return title.present?
    else
      return title_was.present?
    end
  end

  def mixtape?
    if new_record?
      return playlist.present?
    else
      return playlist_id_was.present?
    end
  end

  def review?
    if new_record?
      return work.present?
    else
      return work_id_was.present?
    end
  end

  def type(plural: false)
    base = case
      when standalone?; "Post"
      when mixtape?;    "Playlist"
      when review?;     "#{work.medium.name} Review"
    end

    plural ? base.pluralize : base
  end

  #############################################################################
  # INSTANCE: STATUS METHODS.
  #############################################################################

  def viewable?
    published?
  end

  def unpublished
    draft? || scheduled?
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def prepare_work_for_editing(params = nil)
    return if standalone?

    if current_work_id = params.try(:[], "work_id") || work_id
      self.current_work_id = current_work_id.to_i
      self.work_id         = nil
    end

    build_work unless self.work.present?

    work.prepare_credits
  end

  # TODO mixtape tags
  def all_tags
    Tag.where(id: [self.tag_ids, self.work.try(:tag_ids)].flatten.uniq)
  end

  def alpha_parts
    return [                     title] if standalone?
    return [playlist.try(:alpha_parts)] if mixtape?
    return [    work.try(:alpha_parts)] if review?
  end

private

  #############################################################################
  # AASM PRIVATE METHODS.
  #############################################################################

  def ready_to_publish?
    persisted? && unpublished && valid? && body.present? && slug.present?
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

    if work.present?
      work.update_counts
      medium.update_counts
      contributors.each { |c| c.update_counts }
      creators.each     { |c| c.update_counts }
      work_tags.each    { |t| t.update_counts }
    elsif playlist.present?
      playlist.update_counts
      # TODO update playlist descendent counts
    end
  end
end
