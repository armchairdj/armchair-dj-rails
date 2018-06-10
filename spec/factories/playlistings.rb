FactoryBot.define do
  factory :playlisting do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_existing_playlist do
      playlist_id { create(:minimal_playlist).id }
    end

    trait :with_draft_post do
      after(:create) do |playlisting|
        create(:review, :draft, :with_body, author_id: playlisting.playlist.author.id, work_id: playlisting.work.id)

        playlist.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |playlisting|
        create(:review, :scheduled, :with_body, author_id: playlisting.playlist.author.id, work_id: playlisting.work.id)

        playlist.reload
      end
    end

    trait :with_published_post do
      after(:create) do |playlisting|
        create(:review, :published, :with_body, author_id: playlisting.playlist.author.id, work_id: playlisting.work.id)

        playlist.reload
      end
    end
    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_playlisting do
      with_existing_playlist
      with_existing_work
    end

    factory :complete_playlisting, parent: :minimal_playlisting do
      with_published_post
    end
  end
end
