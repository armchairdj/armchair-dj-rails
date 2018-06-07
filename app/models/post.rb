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

  scope :mixtape,         -> { where.not(playlist_id: nil) }
  scope :review,          -> { where.not(work_id:     nil) }
  scope :standalone,      -> { where.not(title:       nil) }

  scope :eager,           -> { includes(:medium, :work, :creators, :author).references(:medium) }

  scope :for_admin,       -> { eager                        }
  scope :for_site,        -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :tags

  belongs_to :work,     optional: true
  belongs_to :playlist, optional: true

  has_one :medium,         through: :work
  has_many :creators,      through: :work
  has_many :contributors,  through: :work
  has_many :work_tags,     through: :work, class_name: "Tag", source: :tags

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :work, allow_destroy: false,
    reject_if: proc { |attrs| attrs["title"].blank? }

  attr_accessor :current_work_id

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :body, presence: true, unless: :draft?

  validate { has_title_or_postable }

  def has_title_or_postable
    if new_record?
      self.errors.add(:base,        :has_title_and_postable ) if     (title && (work || playlist))
      self.errors.add(:base,        :needs_title_or_postable) unless (title || work || playlist)
    elsif standalone?
      self.errors.add(:title,       :blank                  ) if title.blank?
      self.errors.add(:work_id,     :present                ) if work.present?
    elsif review?
      self.errors.add(:work_id,     :blank                  ) if work.blank?
      self.errors.add(:title,       :present                ) if title.present?
    elsif mixtape?
      self.errors.add(:playlist_id, :blank                  ) if playlist.blank?
      self.errors.add(:title,       :present                ) if title.present?
    end
  end

  private :has_title_or_postable

  validate { only_bare_tags }

  def only_bare_tags
    return if tags.where.not(category_id: nil).empty?

    self.errors.add(:tag_ids, :has_categorized_tags)
  end

  private :only_bare_tags

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    if standalone?
      [ title ]
    elsif review?
      [ "reviews", work.sluggable_parts ]
    elsif mixtape?
      [ "mixes", playlist.sluggable_parts ]
    end
  end

  def slug_locked?
    published?
  end

  def validate_slug_presence?
    !draft?
  end

  private :validate_slug_presence?

  #############################################################################
  # INSTANCE: TYPE METHODS.
  #############################################################################

  def standalone?
    if new_record?
      return title.present?
    else
      return title_was.present?
    end
  end

  def mixtape?
    if new_record?
      return playlist.present?
    else
      return playlist_id_was.present?
    end
  end

  def review?
    if new_record?
      return work.present?
    else
      return work_id_was.present?
    end
  end

  def type(plural: false)
    base = case
      when standalone?; "Post"
      when mixtape?;    "Playlist"
      when review?;     "#{work.medium.name} Review"
    end

    plural ? base.pluralize : base
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def prepare_work_for_editing(params = nil)
    return if standalone?

    if current_work_id = params.try(:[], "work_id") || work_id
      self.current_work_id = current_work_id.to_i
      self.work_id         = nil
    end

    build_work unless self.work.present?

    work.prepare_credits
  end

  # TODO mixtape tags
  def all_tags
    Tag.where(id: [self.tag_ids, self.work.try(:tag_ids)].flatten.uniq)
  end

  def alpha_parts
    return [                     title] if standalone?
    return [playlist.try(:alpha_parts)] if mixtape?
    return [    work.try(:alpha_parts)] if review?
  end

  def update_counts_for_all
    author.update_counts

    tags.each { |t| t.update_counts }

    if work.present?
      work.update_counts_for_all
    elsif playlist.present?
      playlist.update_counts_for_all
    end
  end
end
