# frozen_string_literal: true

FactoryBot.define do
  factory :identity do
    factory :minimal_identity do
      with_associations
    end

    trait :with_associations do
      association :creator,   factory: :primary_creator
      association :pseudonym, factory: :secondary_creator
    end
  end
end
