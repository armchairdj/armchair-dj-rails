# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  PART_SEPARATOR    = "/".freeze
  VERSION_SEPARATOR = "-".freeze
  EMPTY_PART        = "!".freeze

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    def prepare_parts(parts)
      parts.flatten.compact.map { |x| prepare_part(x) }.compact
    end

    def prepare_part(str)
      str = str.underscore.to_ascii.strip
      str = str.gsub("&", "_and_")
      str = str.gsub(/["“”'‘’]/, "")
      str = str.gsub(/[[:punct:]|[:blank:]]/, "_")
      str = str.gsub(/[^[:word:]]/, "")
      str = str.gsub(/_+/, "_").gsub(/^_/, "").gsub(/_$/, "")

      str.blank? ? EMPTY_PART : str
    end
  end

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    ### CONCERNS.

    include FriendlyId

    friendly_id :slug_candidates, use: [:slugged, :history]

    ### ATTRIBUTES.

    attr_accessor :clear_slug

    ### HOOKS.

    before_save :handle_cleared_slug

    ### METHODS. (Must be in included block to work with FriendlyId.)

    # Override default friendly_id behavior since we're already doing
    # our own normalization.
    def normalize_friendly_id(input)
      input
    end

    # Override default friendly_id behavior to use ID instead of slug.
    # This allows IDs in admin and custom routes with slugs for public.
    def to_param
      id.to_s
    end
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def clear_slug?
    !!clear_slug
  end

  def sluggable_parts
    []
  end

private

  def handle_cleared_slug
    self.slug = nil if persisted? && clear_slug?

    valid?
  end

  def slug_candidates
    [:base_slug, :sequenced_slug]
  end

  def base_slug
    self.class.prepare_parts(sluggable_parts).join(PART_SEPARATOR)
  end

  def sequenced_slug
    base     = normalize_friendly_id(base_slug)
    sequence = self.class.where("slug like '#{base}#{VERSION_SEPARATOR}%'").count + 2

    [base, sequence].join(VERSION_SEPARATOR)
  end
end
