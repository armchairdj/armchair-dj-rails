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

class RadioShow < Medium
  def available_facets
    [:audio_show_format, :narrative_genre, :radio_network]
  end
end
