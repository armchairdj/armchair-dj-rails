FactoryBot.define do
  factory :facet do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_category do
      association :category, factory: :minimal_category
    end

    trait :with_existing_category do
      category_id { create(:minimal_category).id }
    end

    trait :with_medium do
      association :medium, factory: :minimal_medium
    end

    trait :with_existing_medium do
      medium_id { create(:minimal_medium).id }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_facet do
      with_category
      with_medium
    end
  end
end
