# frozen_string_literal: true

class Review < ApplicationRecord

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Linkable
  include Sluggable
  include Summarizable

  include Publishable

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:author, :medium, :work, :creators).references(:medium) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work

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

  validates :work, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    work.try(:sluggable_parts) || []
  end

  #############################################################################
  # INSTANCE: TYPE METHODS.
  #############################################################################

  def type(plural: false)
    base = "#{work.medium.name} Review"

    plural ? base.pluralize : base
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def prepare_work_for_editing(params = nil)
    if current_work_id = params.try(:[], "work_id") || work_id
      self.current_work_id = current_work_id.to_i
      self.work_id         = nil
    end

    build_work unless self.work.present?

    work.prepare_credits
  end

  def all_tags
    Tag.where(id: [self.tag_ids, self.work.try(:tag_ids)].flatten.uniq)
  end

  def alpha_parts
    [ work.try(:alpha_parts) ]
  end

  def update_viewable_for_all
    work.update_viewable_for_all
  end
end
