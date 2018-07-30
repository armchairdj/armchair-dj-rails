# frozen_string_literal: true

concern :Sluggable do

  WORD_SEPARATOR         =   "_".freeze
  PART_SEPARATOR         =   "/".freeze
  VERSION_SEPARATOR      =   "-".freeze
  EMPTY_PART_REPLACEMENT = "xxx".freeze

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    def prepare_parts(parts)
      parts.flatten.compact.map { |x| prepare_part(x) }.compact
    end

    def prepare_part(str)
      str = str.underscore.to_ascii.strip
      str = fix_quote_marks(str)
      str = fix_ampersands(str)
      str = fix_non_words(str)
      str = compact_word_separators(str)

      str.blank? ? EMPTY_PART_REPLACEMENT : str
    end

    def fix_quote_marks(str)
      str.gsub(/["“”'‘’]/, "")
    end

    def fix_ampersands(str)
      str.gsub("&", "#{WORD_SEPARATOR}and#{WORD_SEPARATOR}")
    end

    def fix_non_words(str)
      str = str.gsub(/[[:punct:]|[:blank:]]/, WORD_SEPARATOR)
      str = str.gsub(/[^[:word:]]/, "")
    end

    def compact_word_separators(str)
      str = str.gsub( /#{Regexp.quote(WORD_SEPARATOR)}+/, "_")
      str = str.gsub(/^#{Regexp.quote(WORD_SEPARATOR)}/,  "")
      str = str.gsub( /#{Regexp.quote(WORD_SEPARATOR)}$/, "")
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

    attribute :clear_slug, :boolean, default: false

    ### HOOKS.

    before_save :conditionally_reset_slug_and_history
    before_save :handle_clear_slug_checkbox

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

  def sluggable_parts
    []
  end

private

  def handle_clear_slug_checkbox
    return unless should_clear_slug?

    self.slug = nil

    valid? # Regenerates slug
  end

  def should_clear_slug?
    persisted? && published? && clear_slug?
  end

  def conditionally_reset_slug_and_history
    return unless persisted? && should_reset_slug_and_history?

    reset_slug_history
    self.slug = nil

    valid? # Regenerates slug
  end

  def should_reset_slug_and_history?
    unpublished?
  end

  def reset_slug_history
    self.slugs.clear
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
