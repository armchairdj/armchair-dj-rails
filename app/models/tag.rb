class Tag < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope     :eager, -> { includes(:posts) }
  scope :for_admin, -> { eager }
  scope  :for_site, -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :articles, association_foreign_key: "tag_id", join_table: "posts_tags"
  has_and_belongs_to_many :reviews,  association_foreign_key: "tag_id", join_table: "posts_tags"
  has_and_belongs_to_many :mixtapes, association_foreign_key: "tag_id", join_table: "posts_tags"

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def sluggable_parts
    [name]
  end

  def alpha_parts
    [name]
  end
end
