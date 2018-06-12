# frozen_string_literal: true

module Displayable
  extend ActiveSupport::Concern

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Linkable
  include Sluggable
  include Summarizable
  include Viewable
end
