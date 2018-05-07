FactoryBot.define do
  sequence :category_name { |n| "Category #{n}" }

  factory :category do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:category_name) }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_category do
      with_name
    end
  end
end
