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
      transient do
        category_name { generate(:category_name) }
      end

      category_id { create(:minimal_category, name: category_name).id }
    end

    trait :with_existing_year_category do
      association :category, factory: :year_category
    end

    trait :with_draft_post do
      after(:create) do |tag|
        create(:minimal_post, :draft, :with_body, tag_ids: [tag.id])

        tag.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |tag|
        create(:minimal_post, :scheduled, :with_body, tag_ids: [tag.id])

        tag.reload
      end
    end

    trait :with_published_post do
      after(:create) do |tag|
        create(:minimal_post, :published, :with_body, tag_ids: [tag.id])

        tag.reload
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    trait :with_unviewable_work do
      with_existing_category

      after(:create) do |tag|
        work = create(:minimal_work, tag_ids: [tag.id])

        create(:minimal_review, :draft, :with_body, work_id: work.id)

        tag.reload
      end
    end

    trait :with_viewable_work do
      with_existing_category

      after(:create) do |tag|
        work = create(:minimal_work, tag_ids: [tag.id])

        create(:minimal_review, :published, :with_body, work_id: work.id)

        tag.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :year_tag do
      with_year
    end

    factory :string_tag do
      with_existing_string_category

      with_name
    end

    factory :minimal_tag do
      with_name
    end

    factory :complete_tag, parent: :minimal_tag do
      with_summary
    end

    factory :tag_for_item, parent: :minimal_tag do; end

    factory :tag_for_work, parent: :minimal_tag do
      with_existing_category
    end
  end
end
