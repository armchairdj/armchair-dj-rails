# frozen_string_literal: true

concern :Alphabetizable do
  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    scope :alpha, -> { order(:alpha) }

    before_save :set_alpha

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
    [*alpha_parts].compact.join(" ").downcase.squish
  end

  def ensure_alpha
    return if new_record?

    self.errors.add(:base, :missing_alpha) if alpha.blank?
  end
end