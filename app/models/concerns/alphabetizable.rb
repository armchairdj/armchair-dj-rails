# frozen_string_literal: true

module Alphabetizable
  extend ActiveSupport::Concern

  ALPHA_CONNECTOR = " "

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do

    ### SCOPES.

    scope :alpha, -> { order(:alpha) }

    ### HOOKS.

    before_save :set_alpha

    ### VALIDATION.

    validate { ensure_alpha }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

private

  def set_alpha
    self.alpha = calculate_alpha_string
  end

  def calculate_alpha_string
    [alpha_parts].flatten.compact.join(ALPHA_CONNECTOR).downcase.squish
  end

  def ensure_alpha
    return if new_record?

    self.errors.add(:base, :missing_alpha) if alpha.blank?
  end
end