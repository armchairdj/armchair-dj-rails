FactoryBot.define do
  sequence :aspect_name { |n| "aspect #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }

  factory :aspect do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:aspect_name) }
    end

    trait :with_existing_category do
      transient do
        category_name { generate(:category_name) }
      end

      category_id { create(:minimal_category, name: category_name).id }
    end

    trait :with_work do
      after(:create) do |aspect|
        create(:minimal_work, aspect_ids: [aspect.id])

        aspect.reload
      end
    end

    trait :with_draft_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :draft, aspect.works.first.id)

        aspect.reload
      end
    end

    trait :with_scheduled_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :scheduled, aspect.works.first.id)

        aspect.reload
      end
    end

    trait :with_published_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :published, aspect.works.first.id)

        aspect.reload
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

    factory :minimal_aspect do
      with_name
    end

    factory :complete_aspect, parent: :minimal_aspect do
      with_work
      with_summary
    end
  end
end
