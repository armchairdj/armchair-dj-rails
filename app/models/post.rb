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

  belongs_to :postable, polymorphic: true, required: false

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
    ensure_postable_or_title
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

  def postable_gid
    self.postable.to_global_id if self.postable.present?
  end

  def postable_gid=(postable)
    self.postable = GlobalID::Locator.locate postable
  end

  def one_line_title
    if self.postable
      self.postable.display_name_with_creator
    else
      self.title
    end
  end

private

  def ensure_postable_or_title
    has_work  = self.postable.present?
    has_title = self.title.present?

    if has_work && has_title
      self.errors.add(:title, :has_work_and_title)
    elseif !has_work && !has_title
      self.errors.add(:title, :needs_work_or_title)
    end
  end
end
