FactoryBot.define do
  factory :facet do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_category do
      category_id { create(:minimal_category).id }
    end

    trait :with_medium do
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
