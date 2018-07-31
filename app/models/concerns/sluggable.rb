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
      str = remove_quote_marks(str)
      str = replace_ampersands(str)
      str = fix_non_words(str)
      str = compact_word_separators(str)

      str.blank? ? EMPTY_PART_REPLACEMENT : str
    end

    def remove_quote_marks(str)
      str.remove(/["“”'‘’]/)
    end

    def replace_ampersands(str)
      str.gsub("&", "#{WORD_SEPARATOR}and#{WORD_SEPARATOR}")
    end

    def fix_non_words(str)
      str = str.gsub(/[[:punct:]|[:blank:]]/, WORD_SEPARATOR)
      str = str.remove(/[^[:word:]]/)
    end

    def compact_word_separators(str)
      quoted = Regexp.quote(WORD_SEPARATOR)

      str = str.gsub(/#{quoted}+/, WORD_SEPARATOR)
      str = str.remove(/^#{quoted}/)
      str = str.remove(/#{quoted}$/)
    end
  end

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    include FriendlyId

    friendly_id :slug_candidates, use: [:slugged, :history]

    attribute :clear_slug, :boolean, default: false

    before_save :clear_slug_and_history_if_unpublished
    before_save :handle_clear_slug_checkbox

    ####################################################
    # Must be in included block to work with FriendlyId:
    ####################################################

    # Override default friendly_id behavior since we're already doing
    # our own normalization.
    def normalize_friendly_id(input)
      input
    end

    # Override default friendly_id behavior to use ID instead of slug.
    # This allows us to use normal ID URLs in admin and roll our own
    # slug URLs on public pages.
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

  ### Basic slug generation.

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

  ### User-initiated slug regeneration.

  def handle_clear_slug_checkbox
    if should_clear_slug?
      regenerate_slug
    end
  end

  def should_clear_slug?
    persisted? && published? && clear_slug?
  end

  def regenerate_slug
    self.slug = nil

    valid?
  end

  ### Automatic slug regeneration.

  def clear_slug_and_history_if_unpublished
    if should_reset_slug_and_history?
      reset_slug_history

      regenerate_slug
    end
  end

  def should_reset_slug_and_history?
    persisted? && unpublished?
  end

  def reset_slug_history
    self.slugs.clear
  end
end
