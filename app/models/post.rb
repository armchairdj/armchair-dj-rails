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

  validates :body, presence: true

  validates :slug,         presence: true, if: :published?
  validates :published_at, presence: true, if: :published?

  #############################################################################
  # HOOKS.
  #############################################################################

  after_initialize :set_slug

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

    event :publish, before: :prepare_to_publish do
      transitions from: :draft, to: :published
    end
  end

  #############################################################################
  # CLASS.
  #############################################################################

  def self.admin_scopes
    {
      "All"       => :all,
      "Draft"     => :draft,
      "Published" => :published,
    }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def one_line_title
    if self.work
      self.work.title_with_creator
    else
      self.title
    end
  end

private

  def reject_blank_work(work_attributes)
    work_attributes["title"].blank?
  end

  def ensure_work_or_title
    has_work  = self.work.present?
    has_title = self.title.present?

    if has_work && has_title
      self.errors.add(:base, :has_work_and_title)
    elsif !has_work && !has_title
      self.errors.add(:base, :needs_work_or_title)
    end
  end

  def prepare_to_publish
    set_published_at
    set_slug
  end

  def set_published_at
    self.published_at = Time.now
  end

  def set_slug
    self.slugify(:slug, sluggable_parts) if self.slug.blank?
  end

  def sluggable_parts
    if self.title.present?
      [ self.title ]
    elsif self.work.present?
      [
        self.work.human_medium,
        self.work.display_creator(connector: " and "),
        self.work.title
      ]
    end
  end
end
