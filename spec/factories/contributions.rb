# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :contribution do
    factory :minimal_contribution, parent: :contribution_with_creator do; end

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_role do
      role :musical_artist
    end

    trait :with_work do
      association :work, factory: :minimal_work
    end

    trait :with_creator do
      association :creator, factory: :minimal_creator
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :contribution_without_creator do
      with_role
      with_work
    end

    factory :contribution_with_creator do
      with_role
      with_work
      with_creator
    end
  end
end
