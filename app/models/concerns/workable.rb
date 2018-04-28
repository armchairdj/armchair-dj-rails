# frozen_string_literal: true

module Workable
  extend ActiveSupport::Concern

  included do

    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope :alphabetical, -> { eager.order("works.title, works.subtitle") }

    scope     :viewable, -> { eager.where.not(works: { viewable_post_count: 0 }) }

    scope        :eager, -> { includes(:work) }
    scope     :for_site, -> { eager.viewable.alphabetical }
    scope    :for_admin, -> { eager }

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
