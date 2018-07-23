# frozen_string_literal: true

module Linkable
  extend ActiveSupport::Concern

  MAX_LINKS_AT_ONCE = 5.freeze

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    ### ASSOCIATIONS.

    has_many :links, as: :linkable, dependent: :destroy

    ### ATTRIBUTES.

    accepts_nested_attributes_for :links, allow_destroy: true,
      reject_if: proc { |attrs| attrs["url"].blank? }
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def prepare_links
    MAX_LINKS_AT_ONCE.times { self.links.build }
  end
end
