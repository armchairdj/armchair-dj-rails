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

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validate do
    ensure_work_or_title
  end

  validates :body, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

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
end
