# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  PART_SEPARATOR    = "/".freeze
  VERSION_SEPARATOR = "_".freeze 

  included do
    include FriendlyId

    friendly_id :slug_candidates, use: [:slugged, :history]

    def normalize_friendly_id(string)
      super.gsub("-", "_")
    end

    attr_accessor :clear_slug

    def clear_slug?
      !!clear_slug
    end

    before_save :handle_cleared_slug

  private

    def handle_cleared_slug
      self.slug = nil if persisted? && clear_slug?

      valid?
    end

    def slug_candidates
      [:base_slug, :sequenced_slug]
    end

    def base_slug
      parts = sluggable_parts.flatten.compact.map { |x| x.split(PART_SEPARATOR) }.flatten.compact

      generate_slug_from_parts(parts)
    end

    def generate_slug_from_parts(parts)
      parts.join(PART_SEPARATOR)
    end

    def sequenced_slug
      base     = normalize_friendly_id(base_slug)
      sequence = self.class.where("slug like '#{base}#{VERSION_SEPARATOR}%'").count + 2

      [base, sequence].join(VERSION_SEPARATOR)
    end

    def sluggable_parts
      []
    end
  end
end
