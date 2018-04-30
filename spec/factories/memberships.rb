# frozen_string_literal: true

FactoryBot.define do
  factory :membership do
    factory :minimal_membership do
      with_associations
    end

    trait :with_associations do
      association :group,  factory: :collective_creator
      association :member, factory: :individual_creator
    end
  end
end
