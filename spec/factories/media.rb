FactoryBot.define do
  sequence :medium_name { |n| "Medium #{n}" }

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

    trait :with_category do
      facets_attributes { {
        "0" => attributes_for(:facet, :with_existing_category)
      } }
    end

    trait :with_categories do
      facets_attributes { {
        "0" => attributes_for(:facet, :with_existing_category),
        "1" => attributes_for(:facet, :with_existing_category),
        "2" => attributes_for(:facet, :with_existing_category),
      } }
    end

    trait :with_tags do
      with_category

      after(:create) do |medium|
        medium.categories.each do |category|
          3.times { |i| create(:tag, category_id: category.id, name: "#{category.name} Tag #{i}") }
        end

        medium.reload
      end
    end

    trait :with_draft_post do
      after(:create) do |medium|
        create(:review, :draft, body: "body", work_attributes: attributes_for(:minimal_work, medium: medium))

        medium.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |medium|
        create(:review, :scheduled, body: "body", work_attributes: attributes_for(:minimal_work, medium: medium))

        medium.reload
      end
    end

    trait :with_published_post do
      after(:create) do |medium|
        create(:review, :published, body: "body", work_attributes: attributes_for(:minimal_work, medium: medium))

        medium.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_medium do
      with_name
    end

    factory :complete_medium, parent: :minimal_medium do
      with_summary
      with_category
      with_role
    end

    factory :album_medium do
      name "Album"
    end

    factory :song_medium do
      name "Song"
    end
  end
end
