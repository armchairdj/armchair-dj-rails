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

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def slug_locked?
    viewable?
  end

  def validate_slug_presence?
    viewable?
  end

  private :validate_slug_presence?
end
