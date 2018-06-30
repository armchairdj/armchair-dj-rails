# frozen_string_literal: true
# == Schema Information
#
# Table name: milestones
#
#  id         :bigint(8)        not null, primary key
#  activity   :integer          not null
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint(8)
#
# Indexes
#
#  index_milestones_on_activity  (activity)
#  index_milestones_on_work_id   (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#

require "ffaker"

FactoryBot.define do
  factory :milestone do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_activity do
      activity :released
    end

    trait :with_year do
      year { generate(:year) }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :milestone_for_work do
      with_activity
      with_year
    end

    factory :minimal_milestone do
      with_existing_work
      with_activity
      with_year
    end

    factory :complete_milestone, parent: :minimal_milestone do; end
  end
end
