# frozen_string_literal: true

concern :Authorable do
  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    belongs_to :author, class_name: "User", foreign_key: :author_id

    validates :author, presence: true

    validate { author_can_write }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def display_author
    author&.username
  end

private

  def author_can_write
    errors.add(:author, :invalid_author) if author.present? && !author.can_write?
  end
end
