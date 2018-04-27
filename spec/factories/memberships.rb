# frozen_string_literal: true

FactoryBot.define do
  factory :membership do
    factory :minimal_membership do
      with_associations
    end

    trait :with_associations do
      association :creator, factory: :collective_creator
      association :member,  factory: :singular_creator
    end
  end
end
