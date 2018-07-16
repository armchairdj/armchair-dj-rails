# frozen_string_literal: true

module Contributable
  extend ActiveSupport::Concern

  included do
    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope :for_list,  -> { }
    scope :for_show,  -> { includes(:work, :creator) }

    ###########################################################################
    # ASSOCIATIONS.
    ###########################################################################

    belongs_to :work,    inverse_of: model_name.param_key.pluralize.to_sym
    belongs_to :creator, inverse_of: model_name.param_key.pluralize.to_sym

    ###########################################################################
    # VALIDATIONS.
    ###########################################################################

    validates :work,    presence: true
    validates :creator, presence: true
  end

  def display_type
    work.display_medium
  end
end
