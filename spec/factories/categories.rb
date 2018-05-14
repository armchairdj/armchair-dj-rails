FactoryBot.define do
  sequence :category_name { |n| "Category #{n}" }

  factory :category do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:category_name) }
    end

    trait :allow_multiple do
      allow_multiple true
    end

    trait :disallow_multiple do
      allow_multiple false
    end

    trait :with_tags do
      after(:create) do |category|
        3.times { create(:minimal_tag, category_id: category.id) }

        category.reload
      end
    end

    trait :string_format do
      format :string
    end

    trait :year_format do
      format :year
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_category do
      with_name
    end

    factory :complete_category, parent: :minimal_category do
      string_format
      allow_multiple
    end

    factory :year_category, parent: :minimal_category do
      year_format
      disallow_multiple
    end
  end
end
