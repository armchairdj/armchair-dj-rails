# frozen_string_literal: true
# == Schema Information
#
# Table name: work_milestones
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
#  index_work_milestones_on_activity  (activity)
#  index_work_milestones_on_work_id   (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#

require "ffaker"

FactoryBot.define do
  factory :work_milestone, class: Work::Milestone do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_activity do
      activity :created
    end

    trait :with_year do
      year { generate(:year) }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :work_milestone_for_work do
      activity :released
      with_year
    end

    factory :minimal_work_milestone do
      with_work
      with_activity
      with_year
    end

    factory :complete_work_milestone, parent: :minimal_work_milestone do; end
  end
end
