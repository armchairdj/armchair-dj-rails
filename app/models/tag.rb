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

  scope     :for_works, -> { categorized.eager.alpha }
  scope     :for_posts, -> { uncategorized.eager.alpha }

  scope        :string, -> { for_works.where(categories: { format: Category.formats[:string] }) }
  scope          :year, -> { for_works.where(categories: { format: Category.formats[:year  ] }) }

  scope         :eager, -> { includes(:category, :works, :posts, :reviews).references(:category) }
  scope     :for_admin, -> { eager }
  scope      :for_site, -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # has_ancestry

  belongs_to :category, optional: true

  has_many :creators,     -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :reviews

  has_and_belongs_to_many :works

  has_many :work_reviews, through: :works, source: :reviews, class_name: "Review"

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

  def categorized?
    category.present?
  end

  def uncategorized?
    !categorized?
  end

  def string?
    category.try(:string?) || false
  end

  def year?
    category.try(:year?) || false
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

private

  def has_published_content?
    super || self.work_reviews.published.count > 0
  end
end
