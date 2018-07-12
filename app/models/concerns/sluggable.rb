# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  PART_SEPARATOR    = "_".freeze
  VERSION_SEPARATOR = "_".freeze 

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

      str.blank? ? nil : str
    end
  end

  included do
    include FriendlyId

    friendly_id :slug_candidates, use: [:slugged, :history]

    attr_accessor :clear_slug

    before_save :handle_cleared_slug
  end

  def normalize_friendly_id(string)
    super.gsub("-", "_")
  end

  def clear_slug?
    !!clear_slug
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
    generate_slug_from_parts(self.class.prepare_parts(sluggable_parts))
  end

  def sequenced_slug
    base     = normalize_friendly_id(base_slug)
    sequence = self.class.where("slug like '#{base}#{VERSION_SEPARATOR}%'").count + 2

    [base, sequence].join(VERSION_SEPARATOR)
  end

  def sluggable_parts
    []
  end

  def generate_slug_from_parts(parts)
    parts.join(PART_SEPARATOR)
  end
end
