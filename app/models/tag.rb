class Tag < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Summarizable
  include Viewable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope   :categorized, -> { joins(:category) }
  scope :uncategorized, -> { where(category_id: nil) }

  scope     :for_posts, -> { uncategorized.eager.alpha }
  scope     :for_works, -> { categorized.eager.alpha }

  scope        :string, -> { categorized.where(category: { format: Category.formats[:string] }) }
  scope          :year, -> { categorized.where(category: { format: Category.formats[:year  ] }) }

  scope         :eager, -> { left_outer_joins(:category).includes(:works, :posts) }
  scope     :for_admin, -> { eager }
  scope      :for_site, -> { eager.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # has_ancestry

  belongs_to :category, optional: true

  has_and_belongs_to_many :posts

  has_and_belongs_to_many :works

  has_many :creators, through: :works
  has_many :reviews, through: :works, class_name: "Post", source: :posts

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  validates :name, uniqueness: { scope: [:category_id] }

  validates :name, yearness: true, if: Proc.new {
    category.try(:format) == "year"
  }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    return [name] unless categorized?

    [category.try(:name), name]
  end

  def categorized?
    category.present?
  end

  def uncategorized?
    !categorized?
  end

  def display_category(default = "Uncategorized")
    categorized? ? category.name : default
  end

  def display_name
    return self.name unless categorized?

    [self.category.name, self.name].join(": ")
  end

  def all_posts
    indirect_ids = Post.select("id").joins(work: :tags).where("tags_works.tag_id = ?", self.id)
      direct_ids = Post.select("id").joins(      :tags).where("posts_tags.tag_id = ?", self.id)

    Post.where(id: [indirect_ids, direct_ids].flatten.uniq)
  end
end
