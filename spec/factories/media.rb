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

    trait :with_roles do
      roles_attributes { {
        "0" => attributes_for(:role, :with_name),
        "1" => attributes_for(:role, :with_name),
        "2" => attributes_for(:role, :with_name),
      } }
    end

    trait :with_facet do
      facets_attributes { {
        "0" => attributes_for(:minimal_facet)
      } }
    end

    trait :with_facets do
      facets_attributes { {
        "0" => attributes_for(:minimal_facet),
        "1" => attributes_for(:minimal_facet),
        "2" => attributes_for(:minimal_facet),
      } }
    end

    trait :with_tags do
      with_facets

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
      with_tags
    end

    factory :album_medium, parent: :minimal_medium do
      name "Album"
    end

    factory :song_medium, parent: :minimal_medium do
      name "Song"
    end

    factory :book_medium, parent: :minimal_medium do
      name "Book"
    end
  end
end
