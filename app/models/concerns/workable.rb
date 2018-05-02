# frozen_string_literal: true

module Workable
  extend ActiveSupport::Concern

  include Alphabetizable

  included do

    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope     :eager, -> { includes(:work, :creator) }

    scope  :viewable, -> { eager.where.not(works: { viewable_post_count: 0 }) }

    scope  :for_site, -> { viewable.alpha }

    scope :for_admin, -> { eager }

    ###########################################################################
    # ASSOCIATIONS.
    ###########################################################################

    belongs_to :work
    belongs_to :creator

    ###########################################################################
    # VALIDATIONS.
    ###########################################################################

    validates :work,    presence: true
    validates :creator, presence: true
  end
end
