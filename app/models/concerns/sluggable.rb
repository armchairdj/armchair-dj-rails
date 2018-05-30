# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  PART_SEPARATOR    =                       "/".freeze
  VERSION_SEPARATOR =                      "/v".freeze
  FIND_V2_OR_HIGHER = /\/v([2-9]|[1-9]\d{1,})$/.freeze

  class_methods do
    def generate_unique_slug(instance, attribute, parts)
      uniquify_slug(instance, attribute, generate_slug_from_parts(parts))
    end

    def generate_slug_from_parts(parts)
      parts.map { |part| generate_slug_part(part) }.join(PART_SEPARATOR)
    end

    def generate_slug_part(str)
      str = str.underscore.to_ascii.strip
      str = str.gsub("&", "_and_")
      str = str.gsub(/['"]/, "")
      str = str.gsub(/[[:punct:]|[:blank:]]/, "_")
      str = str.gsub(/[^[:word:]]/, "")
      str = str.gsub(/_+/, "_").gsub(/^_/, "").gsub(/_$/, "")

      str.blank? ? "_" : str
    end

    def uniquify_slug(instance, attribute, base)
      return base unless dupe = find_duplicate_slug(instance, attribute, base)

      [base, self.next_slug_index(dupe).to_s].join(VERSION_SEPARATOR)
    end

    def find_duplicate_slug(instance, attribute, slug)
      scope = self.where("#{attribute} LIKE ?", "#{slug}%")
      scope = scope.where.not(id: instance.id) if instance.persisted?
      dupe  = scope.maximum(attribute.to_sym)

      dupe
    end

    def next_slug_index(slug)
      (slug.match(FIND_V2_OR_HIGHER).try(:[], 1) || "1" ).to_i + 1
    end
  end

  included do
    validates :slug, uniqueness: true, allow_blank: true
    validates :slug, presence: true, if: :should_validate_slug_presence?

    validate { preserve_locked_slug }

    before_save :prepare_slug
  end

  def sluggable_parts
    raise NotImplementedError
  end

  def slug_locked?
    persisted?
  end

private

  def prepare_slug
    return if slug_locked?
    return if self.dirty_slug? && !slug_changed?

    if slug_changed? && !slug.blank?
      self.dirty_slug = true

      assign_slug(:slug, slug)
    else
      self.dirty_slug = false

      assign_slug(:slug, sluggable_parts)
    end
  end

  def assign_slug(attribute, *args)
    return unless slug = generate_slug(attribute, *args)

    self.send(:"#{attribute}=", slug)
  end

  def generate_slug(attribute, *args)
    parts = args.flatten.compact.map { |p| p.split(PART_SEPARATOR) }.flatten.compact

    return unless parts.any?

    self.class.generate_unique_slug(self, attribute, parts)
  end

  def preserve_locked_slug
    if slug_locked? && slug_changed?
      self.errors.add(:slug, :locked)
    end
  end

  def should_validate_slug_presence?
    true
  end
end
