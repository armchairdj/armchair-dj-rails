# frozen_string_literal: true

# == Schema Information
#
# Table name: works
#
#  id             :bigint(8)        not null, primary key
#  alpha          :string
#  display_makers :string
#  medium         :string
#  subtitle       :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_works_on_alpha   (alpha)
#  index_works_on_medium  (medium)
#

class VideoGame < Medium
  self.available_aspects = [:tech_platform, :game_studio, :game_mechanic]
end
