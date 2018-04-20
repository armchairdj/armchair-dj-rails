class Post < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  include AASM
  include Sluggable

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work, required: false

  #############################################################################
  # VIRTUAL ATTRIBUTES.
  #############################################################################

  attr_accessor :current_work_id

  #############################################################################
  # NESTED ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :work,
    allow_destroy: true,
    reject_if:     :reject_blank_work

  #############################################################################
  # ENUMS.
  #############################################################################

  enum status: {
    draft:      0,
    published: 10
  }

  enumable_attributes :status

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :review,       -> { where.not(work_id: nil) }
  scope :standalone,   -> { where(    work_id: nil) }
  scope :reverse_cron, -> { order(published_at: :desc)                  }
  scope :eager,        -> { includes(work: { contributions: :creator }) }
  scope :for_admin,    -> { eager                                       }
  scope :for_site,     -> { eager.published.reverse_cron                }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validate { validate_work_and_title }

  validates :status, presence: true

  validates :body,         presence: true, if: :published?
  validates :published_at, presence: true, if: :published?
  validates :slug,         presence: true, if: :published?

  #############################################################################
  # HOOKS.
  #############################################################################

  before_save :handle_slug

  #############################################################################
  # STATE MACHINE.
  #############################################################################

  aasm(
    column:                  :status,
    create_scopes:            true,
    enum:                     true,
    no_direct_assignment:     true,
    whiny_persistence:        false,
    whiny_transitions:        false
  ) do
    state :draft, initial: true
    state :published

    event(:publish,
      before: :prepare_to_publish,
      after:  :update_viewable_counts
    ) { transitions from: :draft, to: :published, guards: [:can_publish?] }

    event(:unpublish,
      before: :prepare_to_unpublish,
      after:  :update_viewable_counts
    ) { transitions from: :published, to: :draft, guards: [:can_unpublish?] }
  end

  #############################################################################
  # CLASS.
  #############################################################################

  def self.admin_scopes
    {
      "Draft"     => :draft,
      "Published" => :published,
      "All"       => :all,
    }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

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

  # TODO Include post type and version
  def one_line_title
    work ? work.title_with_creator : title
  end

  def prepare_work_for_editing
    self.current_work_id = self.work_id
    self.build_work
    self.work.prepare_contributions
  end

  def update_and_publish(params)
    return true if self.update(params) && self.publish!

    self.errors.add(:body, :blank_during_publish) unless body.present?

    return false
  end

  def update_and_unpublish(params)
    # Unpublish first so validation rules change.
    unpublished = self.unpublish!
    updated     = self.reload.update(params)

    unpublished && updated
  end

private

  def reject_blank_work(work_attributes)
    work_attributes["title"].blank?
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

  # TODO include work version
  def sluggable_parts
    if title.present?
      [ title ]
    elsif work.present?
      [
        work.human_medium,
        work.display_creator(connector: " and "),
        work.title
      ]
    end
  end

  def can_publish?
    persisted? && draft? && valid? && body.present? && slug.present?
  end

  def can_unpublish?
    published?
  end

  def prepare_to_publish
    self.published_at = Time.now
  end

  def prepare_to_unpublish
    self.published_at = nil
  end

  def update_viewable_counts
    return unless work.present?

    work.update_counts
    work.creators.each { |c| c.update_counts }
  end
end
