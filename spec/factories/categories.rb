FactoryBot.define do
  sequence :category_name { |n| "Category #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }

  factory :category do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:category_name) }
    end

    trait :allowing_multiple do
      allow_multiple true
    end

    trait :disallowing_multiple do
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
      allowing_multiple
    end

    factory :year_category, parent: :minimal_category do
      year_format
    end

    factory :string_category, parent: :minimal_category do
      string_format
    end
  end
end
