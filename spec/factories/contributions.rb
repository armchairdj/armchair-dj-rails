# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :contribution do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_role do
      association :role, factory: :minimal_role
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_contribution do
      with_role
      with_work
      with_creator
    end
  end
end
