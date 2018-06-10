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

  def self.permitted_aspect_param(category)
    :"#{self.aspect_param(category)}_aspect_ids"
  end

  def self.aspect_param(category)
    # TODO Deal with special characters
    category.name.downcase.gsub(/\s+/, "_")
  end

  def self.grouped_options
    includes(:medium).alpha.group_by{ |w| w.medium.name }.to_a.sort_by(&:first)
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:medium, :credits, :creators, :contributions, :contributors, :reviews, :aspects).references(:medium) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { viewable.includes(:reviews).alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :credits,       inverse_of: :work, dependent: :destroy
  has_many :contributions, inverse_of: :work, dependent: :destroy

  has_many :creators,     through: :credits,       source: :creator, class_name: "Creator"
  has_many :contributors, through: :contributions, source: :creator, class_name: "Creator"

  belongs_to :medium

  has_many :facets,     through: :medium
  has_many :categories, through: :facets

  has_and_belongs_to_many :aspects

  has_many :milestones

  has_many :reviews, dependent: :destroy

  has_many :playlistings, inverse_of: :work, dependent: :destroy
  has_many :playlists, through: :playlistings
  has_many :mixtapes, through: :playlists

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

  #############################################################################
  # HOOKS.
  #############################################################################

  after_initialize :define_aspect_methods

  def define_aspect_methods
    self.categories.each do |category|
          param = self.class.aspect_param(category)
         getter = :"#{param}_aspects"
      id_getter = :"#{param}_aspect_ids"
      id_setter = :"#{param}_aspect_ids="

      self.class.send :define_method, getter do
        Tag.includes(:category).where(id: self.aspect_ids).where(categories: { name: category.name })
      end

      self.class.send :define_method, id_getter do
        self.send(getter).map(&:id)
      end

      self.class.send :define_method, id_setter do |*ids|
        to_remove = self.send(id_getter).delete_if { |id| ids.flatten.include? id }
        to_keep   = [self.aspect_ids, ids].flatten.compact.uniq - to_remove

        self.aspect_ids = to_keep.compact
      end
    end
  end

  private :define_aspect_methods

  #############################################################################
  # INSTANCE.
  #############################################################################

  def aspects_by_category
    collection = self.aspects.alpha.includes(:category)

    collection.group_by{ |t| t.category }.to_a.sort_by(&:first)
  end

  def permitted_aspect_params
    categories.inject({}) do |memo, (cat)|
      memo[:"#{self.class.permitted_aspect_param(cat)}"] = []; memo
    end
  end

  def display_title(full: false)
    return unless persisted?

    parts = [title, subtitle]

    parts.unshift(credited_artists) if full

    parts.compact.join(": ")
  end

  def full_display_title
    display_title(full: true)
  end

  def credited_artists(connector: " & ")
    return creators.alpha.to_a.map(&:name).join(connector) if persisted?

    # So we can correctly calculate memoized alpha value for review during
    # nested object creation.

    unsaved = credits.map { |c| c.creator.try(:name) }.compact

    unsaved.any? ? unsaved.sort.join(connector) : nil
  end

  def all_creators
    Creator.where(id: all_creator_ids)
  end

  def all_creator_ids
    (creators.map(&:id) + contributors.map(&:id)).uniq
  end

  def grouped_parent_dropdown_options
    scope     = self.class.includes(:medium)
    ungrouped = parent_dropdown_options(scope: scope, order: :alpha)

    ungrouped.group_by{ |w| w.medium.name }.to_a.sort_by(&:first)
  end

  def cascade_viewable
    self.update_viewable

    medium.update_viewable

        creators.each(&:update_viewable)
    contributors.each(&:update_viewable)
            aspects.each(&:update_viewable)
  end

  def sluggable_parts
    [
      medium.name.pluralize,
      credited_artists(connector: " and "),
      title,
      subtitle
    ]
  end

  def alpha_parts
    [credited_artists, title, subtitle]
  end
end
