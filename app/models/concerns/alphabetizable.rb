# frozen_string_literal: true

module Alphabetizable
  extend ActiveSupport::Concern

  ALPHA_CONNECTOR = " "

  included do

    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope :alpha, -> { order(:alpha) }

    ###########################################################################
    # HOOKS.
    ###########################################################################

    before_validation :set_alpha

    ###########################################################################
    # VALIDATION.
    ###########################################################################

    validate { ensure_alpha }
  end

private

  def set_alpha
    self.alpha = calculate_alpha_string
  end

  def calculate_alpha_string
    [alpha_parts].flatten.compact.join(ALPHA_CONNECTOR).downcase.squish
  end

  def ensure_alpha
    self.errors.add(:base, :missing_alpha) if alpha.blank?
  end
end