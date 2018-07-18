# frozen_string_literal: true

module Contributable
  extend ActiveSupport::Concern

  included do
    ###########################################################################
    # ASSOCIATIONS.
    ###########################################################################

    belongs_to :work,    inverse_of: model_name.param_key.pluralize.to_sym
    belongs_to :creator, inverse_of: model_name.param_key.pluralize.to_sym

    ###########################################################################
    # ATTRIBUTES.
    ###########################################################################

    delegate :display_medium, to: :work,    allow_nil: true
    delegate :alpha_parts,    to: :work,    allow_nil: true, prefix: true
    delegate :alpha_parts,    to: :creator, allow_nil: true, prefix: true

    ###########################################################################
    # VALIDATIONS.
    ###########################################################################

    validates :work,    presence: true
    validates :creator, presence: true
  end

  def alpha_parts
    [work_alpha_parts, role_name, creator_alpha_parts]
  end
end
