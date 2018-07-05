# == Schema Information
#
# Table name: works
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  medium     :string
#  subtitle   :string
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_works_on_alpha   (alpha)
#  index_works_on_medium  (medium)
#

class App < Medium
  def available_facets
    [:tech_company, :tech_platform]
  end
end