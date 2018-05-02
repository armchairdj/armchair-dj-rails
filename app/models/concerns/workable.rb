# frozen_string_literal: true

module Workable
  extend ActiveSupport::Concern

  included do
    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope         :eager, -> { includes(:work, :creator) }

    scope      :viewable, -> { eager.where.not(works: { viewable_post_count: 0 }) }
    scope  :non_viewable, -> { eager.where(    works: { viewable_post_count: 0 }) }

    scope     :for_admin, -> { eager }
    scope      :for_site, -> { viewable.alpha }

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

  delegate     :viewable?, to: :work
  delegate :non_viewable?, to: :work
end
