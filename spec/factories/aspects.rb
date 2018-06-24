FactoryBot.define do
  factory :aspect do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_facet do
      facet :song_type
    end

    trait :with_name do
      name { generate(:aspect_name) }
    end

    trait :with_work do
      after(:create) do |aspect|
        create(:minimal_song, aspect_ids: [aspect.id])

        aspect.reload
      end
    end

    trait :with_draft_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :draft, work_id: aspect.works.first.id)

        aspect.reload
      end
    end

    trait :with_scheduled_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :scheduled, work_id: aspect.works.first.id)

        aspect.reload
      end
    end

    trait :with_published_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :published, work_id: aspect.works.first.id)

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
      with_facet
      with_name
    end

    factory :complete_aspect, parent: :minimal_aspect do
      with_work
      with_summary
    end
  end
end
