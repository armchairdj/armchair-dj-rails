FactoryBot.define do
  factory :role do
    work_type nil
    name      nil
    initialize_with { Role.find_or_initialize_by(work_type: work_type, name: name) }

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:role_name) }
    end

    trait :with_work_type do
      work_type "Song"
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_role do
      with_name
      with_work_type
    end

    factory :complete_role, parent: :minimal_role do; end
  end
end
