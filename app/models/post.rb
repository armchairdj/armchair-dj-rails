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
    whiny_transitions:    true,
    enum:                 true,
    no_direct_assignment: true,
    create_scopes:        true
  ) do
    state :draft, initial: true
    state :published

    event :publish, before: :set_published_at, after: :update_counts do
      transitions from: :draft, to: :published
    end
  end

  #############################################################################
  # CLASS.
  #############################################################################

  def self.admin_scopes
    {
      'Draft'     => :draft,
      'Published' => :published,
      'All'       => :all,
    }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def can_publish?
    persisted? && valid? && slug.present? && body.present?
  end

  # TODO Include post Type and Version
  def one_line_title
    if self.work
      self.work.title_with_creator
    else
      self.title
    end
  end

private

  def reject_blank_work(work_attributes)
    work_attributes['title'].blank?
  end

  def ensure_work_or_title
    has_work  = self.work
    has_title = self.title

    if has_work && has_title
      self.errors.add(:base, :has_work_and_title)
    elsif !has_work && !has_title
      self.errors.add(:base, :needs_work_or_title)
    end
  end

  def set_published_at
    self.published_at = Time.now
  end

  def set_slug
    self.slugify(:slug, sluggable_parts)
  end

  # TODO include work version
  def sluggable_parts
    if self.title.present?
      [ self.title ]
    elsif self.work.present?
      [
        self.work.human_medium,
        self.work.display_creator(connector: ' and '),
        self.work.title
      ]
    end
  end

  def update_counts
    return unless self.work.present?

    self.work.save
    self.work.creators.each { |c| c.save }
  end
end
