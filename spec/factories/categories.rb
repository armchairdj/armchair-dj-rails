FactoryBot.define do
  sequence :category_name { |n| "Category #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }

  factory :category do
    name nil
    initialize_with { Category.find_or_initialize_by(name: name) }

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

    trait :with_aspects do
      after(:create) do |category|
        3.times { create(:minimal_aspect, category_id: category.id) }

        category.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_category do
      with_name
    end

    factory :complete_category, parent: :minimal_category do
      allowing_multiple
    end
  end
end
