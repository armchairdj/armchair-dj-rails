# frozen_string_literal: true

class Work < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_CREDITS_AT_ONCE       =  3.freeze
  MAX_CONTRIBUTIONS_AT_ONCE = 10.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Parentable
  include Displayable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.permitted_tag_param(category)
    :"#{self.tag_param(category)}_tag_ids"
  end

  def self.tag_param(category)
    # TODO Deal with special characters
    category.name.downcase.gsub(/\s+/, "_")
  end

  def self.grouped_options
    includes(:medium).alpha.group_by{ |w| w.medium.name }.to_a.sort_by(&:first)
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { joins(:medium).includes(:medium, :credits, :creators, :contributions, :contributors, :posts) }

  scope :for_admin, -> { eager }
  scope :for_site,  -> { viewable.includes(:posts).alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :credits,       inverse_of: :work, dependent: :destroy
  has_many :contributions, inverse_of: :work, dependent: :destroy

  has_many :creators,     through: :credits,       source: :creator, class_name: "Creator"
  has_many :contributors, through: :contributions, source: :creator, class_name: "Creator"

  has_many :posts, dependent: :destroy

  belongs_to :medium

  has_many :facets,     through: :medium
  has_many :categories, through: :facets

  has_and_belongs_to_many :tags

  has_many :playlistings, inverse_of: :work, dependent: :destroy
  has_many :playlists, through: :playlistings

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  # Credits.

  accepts_nested_attributes_for :credits, allow_destroy: true,
    reject_if: proc { |attrs| attrs["creator_id"].blank? }

  def prepare_credits
    MAX_CREDITS_AT_ONCE.times { self.credits.build }
  end

  # Contributions.

  accepts_nested_attributes_for :contributions, allow_destroy: true,
    reject_if: proc { |attrs| attrs["creator_id"].blank? }

  def prepare_contributions
    MAX_CONTRIBUTIONS_AT_ONCE.times { self.contributions.build }
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true

  validates :title, presence: true

  validates :credits, length: { minimum: 1 }

  validate_nested_uniqueness_of :credits,       uniq_attr: :creator_id
  validate_nested_uniqueness_of :contributions, uniq_attr: :creator_id, scope: [:role_id]

  validate { only_categorized_tags }

  def only_categorized_tags
    return if tags.where(category_id: nil).empty?

    self.errors.add(:tag_ids, :uncategorized_tags)
  end

  private :only_categorized_tags

  #############################################################################
  # HOOKS.
  #############################################################################

  after_initialize :define_tag_methods

  def define_tag_methods
    self.categories.each do |category|
          param = self.class.tag_param(category)
         getter = :"#{param}_tags"
      id_getter = :"#{param}_tag_ids"
      id_setter = :"#{param}_tag_ids="

      self.class.send :define_method, getter do
        Tag.includes(:category).where(id: self.tag_ids).where(categories: { name: category.name })
      end

      self.class.send :define_method, id_getter do
        self.send(getter).map(&:id)
      end

      self.class.send :define_method, id_setter do |*ids|
        to_remove = self.send(id_getter).delete_if { |id| ids.flatten.include? id }
        to_keep   = [self.tag_ids, ids].flatten.compact.uniq - to_remove

        self.tag_ids = to_keep.compact
      end
    end
  end

  private :define_tag_methods

  #############################################################################
  # INSTANCE.
  #############################################################################

  def tags_by_category(for_site: false)
    viewable_tags = for_site ? self.tags.for_site : self.tags

    collection = viewable_tags.alpha.includes(:category)

    return [] if collection.empty?

    collection.group_by{ |t| t.category }.to_a.sort_by(&:first)
  end

  def permitted_tag_params
    categories.inject({}) do |memo, (cat)|
      memo[:"#{self.class.permitted_tag_param(cat)}"] = []; memo
    end
  end

  def display_title(full: false)
    return unless persisted?

    parts = [title, subtitle]

    parts.unshift(display_creators) if full

    parts.compact.join(": ")
  end

  def full_display_title
    display_title(full: true)
  end

  def display_creators(connector: " & ")
    return creators.alpha.to_a.map(&:name).join(connector) if persisted?

    # So we can correctly calculate memoized alpha post value during
    # nested object creation.

    unsaved = credits.map{ |c| c.creator.try(:name) }.compact

    unsaved.any? ? unsaved.sort.join(connector) : nil
  end

  def alpha_parts
    [display_creators, title, subtitle]
  end

  def grouped_parent_dropdown_options
    scope     = self.class.includes(:medium)
    ungrouped = parent_dropdown_options(scope: scope, order: :alpha)

    ungrouped.group_by{ |w| w.medium.name }.to_a.sort_by(&:first)
  end

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    [
      medium.name.pluralize,
      display_creators(connector: " and "),
      title,
      subtitle
    ]
  end
end
