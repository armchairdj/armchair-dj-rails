# frozen_string_literal: true

class Post < ApplicationRecord

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Linkable
  include Publishable
  include Sluggable
  include Summarizable

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:author) }
  scope :for_admin, -> { eager                        }
  scope :for_site,  -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :title, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    [ title ]
  end

  #############################################################################
  # INSTANCE: TYPE METHODS.
  #############################################################################

  def type(plural: false)
    "Post"
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def all_tags
    tags
  end

  def alpha_parts
    [ title ]
  end

  def update_counts_for_all
    # Do nothing.
  end
end
