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

    factory :minimal_medium do
      with_name
    end

    factory :album_medium do
      name "Album"
    end

    factory :song_medium do
      name "Song"
    end
  end
end
