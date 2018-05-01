# frozen_string_literal: true

module Alphabetizable
  extend ActiveSupport::Concern

  ALPHA_CONNECTOR = " "

  included do
    scope :alpha, -> { order(:alpha) }

    before_validation :set_alpha

    validate { ensure_alpha }
  end

private

  def set_alpha
    self.alpha = calculate_alpha_string
  end

  def ensure_alpha
    self.errors.add(:base, :missing_alpha) if alpha.blank?
  end

  def calculate_alpha_string
    alpha_parts.flatten.compact.join(ALPHA_CONNECTOR).downcase
  end
end