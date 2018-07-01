# == Schema Information
#
# Table name: works
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  subtitle   :string
#  title      :string           not null
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_works_on_alpha  (alpha)
#  index_works_on_type   (type)
#

class Product < Medium

  #############################################################################
  # CLASS.
  #############################################################################

  def self.facets
    [:manufacturer, :product_type]
  end

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end
