# frozen_string_literal: true

module Contributable
  extend ActiveSupport::Concern

  included do
    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope :eager,      -> { includes(:work, :creator) }

    scope :viewable,   -> { eager.where(works: { viewable: true  }) }
    scope :unviewable, -> { eager.where(works: { viewable: false }) }

    scope :for_admin,  -> { eager }
    scope :for_site,   -> { eager.viewable.alpha }

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

  delegate :viewable?,   to: :work
  delegate :unviewable?, to: :work

  def display_type
    work.model_name.human
  end
end
