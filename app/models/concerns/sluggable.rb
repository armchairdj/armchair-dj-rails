module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    def generate_slug_part(str)
      str = str.gsub("&", "and")
      str = str.gsub(/[[:punct:]|[:blank:]]/, "_")
      str = str.underscore
      str = str.gsub(/[^[:word:]]/, "")
      str = str.gsub(/_$/, "")
    end

    def generate_slug(parts)
      parts.map { |part| generate_slug_part(part) }.join("/")
    end
  end

  included do
    validates :slug, uniqueness: true, allow_blank: true
  end

  def slugify(attribute, *args)
    return unless parts = args.flatten.compact

    self.send(:"#{attribute}=", generate_unique_slug(attribute, parts))
  end

  def generate_unique_slug(attribute, parts)
    base = self.class.generate_slug(parts)
    dupe = find_duplicate_slug(attribute, base)

    return base if dupe.nil?

    [base, next_slug_index(dupe).to_s].join("_")
  end

  def find_duplicate_slug(attribute, slug)
    self.class.where("#{attribute} LIKE ?", "%#{slug}%").maximum(attribute.to_sym)
  end

  def next_slug_index(slug)
    ( slug.match( /_(\d+)$/ ).try(:[], 1) || "0" ).to_i + 1
  end
end
