FactoryBot.define do
  sequence :genre_name { |n| "Genre #{n}" }

  factory :genre do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:genre_name) }
    end

    trait :with_medium do
      association :medium, factory: :minimal_medium
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_genre do
      with_name
      with_medium
    end
  end
end
