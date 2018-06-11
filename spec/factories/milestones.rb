# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :milestone do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_action do
      action :released
    end

    trait :with_year do
      year { generate(:year) }
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
