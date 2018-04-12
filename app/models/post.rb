class Post < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

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

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :reverse_cron, -> { order(published_at: :desc) }
  scope :for_admin,    -> { includes(work: { contributions: :creator } ) }
  scope :for_site,     -> { for_admin.where.not(published_at: nil) }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validate do
    ensure_work_or_title
  end

  validates :body, presence: true

  validates :slug, uniqueness: true, allow_blank: true
  validates :slug, presence: true, if: :published?

  #############################################################################
  # HOOKS.
  #############################################################################

  after_initialize :ensure_slug

  #############################################################################
  # CLASS.
  #############################################################################

  def self.slugify(str)
    str.gsub("&", "and").gsub(/[[:punct:]|[:blank:]]/, "_").underscore.gsub(/[^[:word:]]/, "")
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

  def published?
    self.published_at.present?
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

  def ensure_slug
    return unless self.slug.blank?
    return unless self.work.present? || self.title.present?

    self.slug = generate_slug
  end

  def generate_slug
    return self.class.slugify(self.title) if self.title.present?

    [
      self.work.human_medium,
      self.work.creators.map(&:name).join(" and "),
      self.work.title
    ].map { |str| self.class.slugify(str) }.join("/")
  end
end
