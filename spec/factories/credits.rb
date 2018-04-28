# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :credit do
    factory :minimal_credit, parent: :credit_with_existing_creator do; end

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_work do
      association :work, factory: :minimal_work
    end

    trait :with_new_creator do
      creator_attributes { {
        "0" => { "name" => FFaker::Music.artist }
      } }
    end

    trait :with_existing_creator do
      association :creator, factory: :minimal_creator
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :credit_without_creators do
      with_work
    end

    factory :credit_with_new_creator do
      with_work
      with_new_creator
    end

    factory :credit_with_existing_creator do
      with_work
      with_existing_creator
    end
  end
end
