# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :contribution do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_role do
      role_id { create(:minimal_role).id }
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

    factory :minimal_contribution do
      with_role
      with_work
      with_creator
    end
  end
end
