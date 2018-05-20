FactoryBot.define do
  sequence :tag_name { |n| "tag #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }
  sequence :tag_name_year { |n| rand(1..2020) }

  factory :tag do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:tag_name) }
    end

    trait :with_year do
      with_existing_year_category

      name { generate(:tag_name_year) }
    end

    trait :with_existing_category do
      with_existing_string_category
    end

    trait :with_existing_string_category do
      category_id { create(:minimal_category).id }
    end

    trait :with_existing_year_category do
      association :category, factory: :year_category
    end

    trait :with_viewable_work do
      with_existing_category

      after(:create) do |tag|
        medium = create(:minimal_medium, facets_attributes: {
          "0" => attributes_for(:facet, category_id: tag.category.id)
        })

        work = create(:work, :with_title, :with_one_credit, medium_id: medium.id, tag_ids: [tag.id])

        post = create(:review, work_id: work.id)

        tag.reload
      end
    end

    trait :with_draft_post do
      after(:create) do |tag|
        create(:standalone_post, :draft, body: "body", tag_ids: [tag.id])

        tag.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |tag|
        create(:standalone_post, :scheduled, body: "body", tag_ids: [tag.id])

        tag.reload
      end
    end

    trait :with_published_post do
      after(:create) do |tag|
        create(:standalone_post, :published, body: "body", tag_ids: [tag.id])

        tag.reload
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

    factory :year_tag do
      with_year
    end

    factory :minimal_tag do
      with_name
    end

    factory :complete_tag do
      with_name
      with_summary
      with_existing_category
    end

    factory :tag_for_post, parent: :minimal_tag do; end

    factory :tag_for_work, parent: :complete_tag do; end
  end
end
