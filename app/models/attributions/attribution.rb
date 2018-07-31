# frozen_string_literal: true

class Attribution < ApplicationRecord

  #############################################################################
  # CONCERNING: STI subclass contract.
  #############################################################################

  validates :type, presence: true

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  delegate :alpha_parts, to: :work,    allow_nil: true, prefix: true
  delegate :alpha_parts, to: :creator, allow_nil: true, prefix: true

  def alpha_parts
    [work_alpha_parts, role_name, creator_alpha_parts]
  end

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  belongs_to :work, inverse_of: :attributions

  validates :work, presence: true

  delegate :display_medium, to: :work, allow_nil: true

  #############################################################################
  # CONCERNING: Creator.
  #############################################################################

  belongs_to :creator, inverse_of: :attributions

  validates :creator, presence: true
end
