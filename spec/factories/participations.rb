# frozen_string_literal: true

FactoryBot.define do
  factory :participation do
    factory :minimal_participation, parent: :known_as

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :known_as_relationship do
      relationship :known_as
    end

    trait :has_name_relationship do
      relationship :has_name
    end

    trait :member_of_relationship do
      relationship :member_of
    end

    trait :has_member_relationship do
      relationship :has_member
    end

    trait :with_associations do
      association :creator,     factory: :minimal_creator
      association :participant, factory: :minimal_creator
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :known_as do
      known_as_relationship
      with_associations
    end

    factory :has_name do
      has_name_relationship
      with_associations
    end

    factory :member_of do
      member_of_relationship
      with_associations
    end

    factory :has_member do
      has_member_relationship
      with_associations
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ##########################################################################

  end
end
