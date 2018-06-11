FactoryBot.define do
  factory :medium do
    name nil
    initialize_with { Medium.find_or_initialize_by(name: name) }

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:medium_name) }
    end

    trait :with_role do
      roles_attributes { {
        "0" => attributes_for(:role, :with_name)
      } }
    end

    trait :with_roles do
      roles_attributes { {
        "0" => attributes_for(:role, :with_name),
        "1" => attributes_for(:role, :with_name),
        "2" => attributes_for(:role, :with_name),
      } }
    end

    trait :with_facet do
      facets_attributes { {
        "0" => attributes_for(:facet, :with_existing_category),
      } }
    end

    trait :with_facets do
      facets_attributes { {
        "0" => attributes_for(:facet, :with_existing_category),
        "1" => attributes_for(:facet, :with_existing_category),
        "2" => attributes_for(:facet, :with_existing_category),
      } }
    end

    trait :with_aspects do
      with_facets

      transient do
        aspect_count 3
      end

      after(:create) do |medium, evaluator|
        medium.categories.each do |category|
          evaluator.aspect_count.times { |i| create(:aspect, category_id: category.id, name: "#{category.name} Tag #{i}") }
        end

        medium.reload
      end
    end

    trait :with_draft_post do
      after(:create) do |medium|
        create(:minimal_review, :draft, work_attributes: attributes_for(:minimal_song, medium: medium))

        medium.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |medium|
        create(:minimal_review, :scheduled, work_attributes: attributes_for(:minimal_song, medium: medium))

        medium.reload
      end
    end

    trait :with_published_post do
      after(:create) do |medium|
        create(:minimal_review, :published, work_attributes: attributes_for(:minimal_song, medium: medium))

        medium.reload
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :medium_without_role do
      skip_validation
      with_name
    end

    factory :minimal_medium do
      with_name
      with_role
    end

    factory :complete_medium do
      with_name
      with_summary
      with_roles
      with_aspects
    end
  end
end
