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

  scope :for_admin,    -> { eager                                       }
  scope :for_site,     -> { eager.published.reverse_cron                }
  scope :eager,        -> { includes(work: { contributions: :creator }) }
  scope :reverse_cron, -> { order(published_at: :desc)                  }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validate do
    ensure_work_or_title
  end

  validates :status, presence: true

  validates :body,         presence: true, if: :published?
  validates :slug,         presence: true, if: :published?
  validates :published_at, presence: true, if: :published?

  #############################################################################
  # HOOKS.
  #############################################################################

  before_create :set_slug

  #############################################################################
  # STATE MACHINE.
  #############################################################################

  aasm(
    column:               :status,
    whiny_persistence:    false,
    whiny_transitions:    false,
    enum:                 true,
    no_direct_assignment: true,
    create_scopes:        true
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
    title.present?
  end

  def review?
    work.present?
  end

  # TODO Include post Type and Version
  def one_line_title
    work ? work.title_with_creator : title
  end

  def simulate_validation_for_publishing
    self.errors.add(:body, :blank) unless body.present?
    self.errors.add(:slug, :blank) unless slug.present?
  end

private

  def reject_blank_work(work_attributes)
    work_attributes["title"].blank?
  end

  def ensure_work_or_title
    if work && title
      self.errors.add(:base, :has_work_and_title)
    elsif !work && !title
      self.errors.add(:base, :needs_work_or_title)
    end
  end

  def set_slug
    slugify(:slug, sluggable_parts)
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
