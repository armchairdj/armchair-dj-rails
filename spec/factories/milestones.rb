# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  sequence :milestone_year { |n| rand(1..2020) }

  factory :milestone do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_action do
      action :released
    end

    trait :with_year do
      year { generate(:milestone_year) }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_milestone do
      with_existing_work
      with_action
      with_year
    end

    factory :complete_milestone, parent: :minimal_milestone do; end
  end
end
