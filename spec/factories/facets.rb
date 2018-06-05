FactoryBot.define do
  factory :facet do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_existing_category do
      category_id { create(:minimal_category).id }
    end

    trait :with_existing_medium do
      medium_id { create(:minimal_medium).id }
    end

    trait :with_tags do
      category_id { create(:minimal_category, :with_tags).id }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_facet do
      with_existing_category
      with_existing_medium
    end

    factory :complete_facet, parent: :minimal_facet do

    end
  end
end
