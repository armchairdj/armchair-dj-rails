class Post < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  include AASM

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

  validates :slug, uniqueness: true, allow_blank: true

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

  def self.slugify(str)
    str = str.gsub("&", "and")
    str = str.gsub(/[[:punct:]|[:blank:]]/, "_")
    str = str.underscore
    str = str.gsub(/[^[:word:]]/, "")
    str = str.gsub(/_$/, "")
  end

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

  def set_slug(index = nil)
    index ||= 0

    return unless index <= 10
    return unless self.slug.blank?
    return unless self.work.present? || self.title.present?

    self.slug = generate_slug(index)

    unless valid_attribute?(:slug)
      self.slug = nil

      self.set_slug(index + 1)
    end
  end

  def generate_slug(index = 0)
    slug = if self.title.present?
      self.class.slugify(self.title)
    else
      [
        self.work.human_medium,
        self.work.creators.map(&:name).join(" and "),
        self.work.title
      ].map { |str| self.class.slugify(str) }.join("/")
    end

    slug = "#{slug}_#{index}" unless index == 0

    slug
  end
end
