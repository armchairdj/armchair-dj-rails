class Tag < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Displayable

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

  scope         :eager, -> { includes(:category, :works, :posts).references(:category) }
  scope     :for_admin, -> { eager }
  scope      :for_site, -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # has_ancestry

  belongs_to :category, optional: true

  has_and_belongs_to_many :works

  has_many :creators,     -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  has_and_belongs_to_many :posts

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

  def all_posts
    Post.where(id: (reviews.map(&:id) + posts.map(&:id)).uniq)
  end

  def categorized?
    category.present?
  end

  def uncategorized?
    !categorized?
  end

  def display_category(default: "Uncategorized")
    categorized? ? category.name : default
  end

  def display_name(connector: ": ")
    [self.category.try(:name), self.name].compact.join(connector)
  end

  def sluggable_parts
    [display_name(connector: "/")]
  end

  def alpha_parts
    return [name] unless categorized?

    [category.try(:name), name]
  end
end
