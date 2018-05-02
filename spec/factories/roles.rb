FactoryBot.define do
  sequence :role_name { |n| "Role #{n}" }

  factory :role do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:role_name) }
    end

    trait :with_medium do
      association :medium, factory: :minimal_medium
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_role do
      with_name
      with_medium
    end
  end
end
