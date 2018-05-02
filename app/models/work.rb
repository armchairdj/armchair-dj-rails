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
  #     { "creator_id" => attrs["creator_id"].to_s, "role" => attrs["role"].to_s }
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

  #############################################################################
  # INSTANCE.
  #############################################################################

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
