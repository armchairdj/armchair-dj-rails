FactoryBot.define do
  sequence :category_name { |n| "Category #{n}" }

  factory :category do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:category_name) }
    end

    trait :with_tags do
      after(:create) do |category|
        3.times { create(:minimal_tag, category_id: category.id) }

        category.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_category do
      with_name
    end
  end
end
