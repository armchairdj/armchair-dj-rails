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

  def self.model_name
    ActiveModel::Name.new(self, nil, "Work")
  end

  def self.grouped_options
    order(:type, :alpha).group_by{ |x| x.model_name.human }.to_a
  end

  def self.available_roles
    Role.where(work_type: self.model_name.name)
  end

  def self.available_parents
    self.superclass.where(type: available_parent_types.map{ |x| x.model_name.name })
  end

  def self.available_parent_types
    [self]
  end

  def self.type_options
    load_descendants

    descendants.map { |s| [s.model_name.name, s.model_name.human] }.sort_by(&:last)
  end

  def self.load_descendants
    return if descendants.any?

    Dir["#{Rails.root}/app/models/works/*.rb"].each do |file|
      next if File.basename(file, ".rb") == File.basename(__FILE__, ".rb")

      require_dependency file
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:aspects, :credits, :creators, :contributions, :contributors, :playlists, :reviews, :mixtapes) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :milestones

  has_and_belongs_to_many :aspects

  has_many :credits,       inverse_of: :work, dependent: :destroy
  has_many :contributions, inverse_of: :work, dependent: :destroy

  has_many :creators,     through: :credits,       source: :creator, class_name: "Creator"
  has_many :contributors, through: :contributions, source: :creator, class_name: "Creator"

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

  validates :type, presence: true
  validates :title, presence: true

  validates :credits, length: { minimum: 1 }

  validate_nested_uniqueness_of :credits,       uniq_attr: :creator_id
  validate_nested_uniqueness_of :contributions, uniq_attr: :creator_id, scope: [:role_id]

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

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
    # TODO FIX ORDERING
    scope     = self.class.available_parents
    ungrouped = parent_dropdown_options(scope: scope, order: :alpha)

    ungrouped.group_by(&:type).to_a.sort_by(&:first)
  end

  def cascade_viewable
    self.update_viewable

        creators.each(&:update_viewable)
    contributors.each(&:update_viewable)
         aspects.each(&:update_viewable)
  end

  def sluggable_parts
    [
      model_name.human.pluralize,
      credited_artists(connector: " and "),
      title,
      subtitle
    ]
  end

  def alpha_parts
    [credited_artists, title, subtitle]
  end
end
