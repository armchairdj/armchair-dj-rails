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

  include Alphabetizable
  include Summarizable
  include Viewable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.grouped_options
    joins(:medium).alpha.group_by{ |w| w.medium.name }.to_a.sort_by(&:first)
  end

  def self.admin_scopes
    {
      "All"          => :for_admin,
      "Viewable"     => :viewable,
      "Non-Viewable" => :non_viewable,
    }
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:medium, :credits, :creators, :contributions, :contributors, :posts) }

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

  # def contributions_attributes=(attributes)
  #   puts "contributions_attributes="
  #
  #   uniques = (attributes.values.map do |item_attributes|
  #     attrs = item_attributes.stringify_keys
  #
  #     { "creator_id" => attrs["creator_id"].to_s, "role_id" => attrs["role_id"].to_s }
  #   end).compact.map.uniq
  #
  #   puts ">>uniques", uniques
  #
  #   deduped = uniques.each.with_index(0).inject({}) do |memo, (item, index)|
  #     memo[index.to_s] = item; memo
  #   end
  #
  #   puts ">>deduped", deduped
  #
  #   super(deduped)
  # end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true

  validates :title, presence: true

  validate { at_least_one_credit }

  def at_least_one_credit
    return if self.credits.reject(&:marked_for_destruction?).any?

    self.errors.add(:credits, :missing)
  end

  private :at_least_one_credit

  #############################################################################
  # HOOKS.
  #############################################################################

  after_initialize :define_tag_methods

  def define_tag_methods
    self.categories.each do |category|
      getter_name = :"#{tag_param(category)}_tags"
      setter_name = :"#{tag_param(category)}_tag_ids="

      self.class.send :define_method, getter_name do
        self.tags.includes(:category).where(categories: { name: category.name })
      end

      self.class.send :define_method, setter_name do |*ids|
        to_remove = self.send(getter_name).map(&:id).delete_if { |id| ids.flatten.include? id }
        to_keep   = [self.tag_ids, ids].flatten.compact.uniq - to_remove

        self.tag_ids = to_keep.compact
      end
    end
  end

  private :define_tag_methods

  #############################################################################
  # INSTANCE.
  #############################################################################

  def permitted_tag_params
    categories.map { |c| { :"#{self.tag_param(c)}_tag_ids" => [] } }
  end

  def tag_param(category)
    # TODO Deal with special characters
    category.name.downcase.gsub(/\s+/, "_")
  end

  # TODO This should take a full option and full_display_title should just call this
  def display_title
    return unless persisted?

    [title, subtitle].compact.join(": ")
  end

  def full_display_title
    return unless persisted?

    [display_creators, title, subtitle].compact.join(": ")
  end

  def display_creators(connector: " & ")
    return creators.alpha.to_a.map(&:name).join(connector) if persisted?

    # So we can correctly calculate memoized alpha post value during
    # nested objectcreation.

    unsaved = credits.map{ |c| c.creator.try(:name) }.compact

    unsaved.any? ? unsaved.sort.join(connector) : nil
  end

  def alpha_parts
    [display_creators, title, subtitle]
  end
end
