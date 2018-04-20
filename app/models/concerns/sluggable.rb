module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    def generate_unique_slug(instance, attribute, parts)
      uniquify_slug(instance, attribute, generate_slug_from_parts(parts))
    end

    def generate_slug_from_parts(parts)
      parts.map { |part| generate_slug_part(part) }.join("/")
    end

    def generate_slug_part(str)
      str = str.gsub("&", "_and_")
      str = str.gsub(/[[:punct:]|[:blank:]]/, "_")
      str = str.gsub(/[^[:word:]]/, "")
      str = str.underscore
      str = str.gsub(/_+/, "_").gsub(/^_/, "").gsub(/_$/, "")
    end

    def uniquify_slug(instance, attribute, base)
      return base unless dupe = find_duplicate_slug(instance, attribute, base)

      incremented = [base, self.next_slug_index(dupe).to_s].join("/")

      incremented
    end

    def find_duplicate_slug(instance, attribute, slug)
      scope = self.where("#{attribute} LIKE ?", "#{slug}%")
      scope = scope.where.not(id: instance.id) if instance.persisted?
      dupe  = scope.maximum(attribute.to_sym)

      dupe
    end

    def next_slug_index(slug)
      (slug.match( /\/(\d+)$/).try(:[], 1) || "0" ).to_i + 1
    end
  end

  included do
    validates :slug, uniqueness: true, allow_blank: true
  end

  def slugify(attribute, *args)
    return unless slug = generate_slug(attribute, *args)

    self.send(:"#{attribute}=", slug)
  end

  def generate_slug(attribute, *args)
    return unless (parts = args.flatten.compact).any?

    self.class.generate_unique_slug(self, attribute, parts)
  end
end
