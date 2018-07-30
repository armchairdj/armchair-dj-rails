# frozen_string_literal: true

concern :Contributable do

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  concerning :Alpha do
    included do
      include Alphabetizable

      delegate :alpha_parts,    to: :work,    allow_nil: true, prefix: true
      delegate :alpha_parts,    to: :creator, allow_nil: true, prefix: true
    end

    def alpha_parts
      [work_alpha_parts, role_name, creator_alpha_parts]
    end
  end

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    belongs_to :work,    inverse_of: model_name.param_key.pluralize.to_sym
    belongs_to :creator, inverse_of: model_name.param_key.pluralize.to_sym

    validates :work,    presence: true
    validates :creator, presence: true

    delegate :display_medium, to: :work, allow_nil: true
  end
end
