# frozen_string_literal: true

module Authorable
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: "User", foreign_key: :author_id

    validates :author, presence: true

    validate { author_can_write }
  end

  def display_author
    author.try(:username)
  end

private

  def author_can_write
    if author.present? && !author.can_write?
      self.errors.add(:author, :invalid_author)
    end
  end
end
