FactoryBot.define do
  factory :playlist do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_title do
      title { FFaker::HipsterIpsum.phrase.titleize }
    end

    trait :with_2_tracks do
      playlistings_attributes { {
        "0" => attributes_for(:playlisting, :with_existing_work),
        "1" => attributes_for(:playlisting, :with_existing_work),
      } }
    end

    trait :with_10_tracks do
      playlistings_attributes { {
        "0" => attributes_for(:playlisting, :with_existing_work),
        "1" => attributes_for(:playlisting, :with_existing_work),
        "2" => attributes_for(:playlisting, :with_existing_work),
        "3" => attributes_for(:playlisting, :with_existing_work),
        "4" => attributes_for(:playlisting, :with_existing_work),
        "5" => attributes_for(:playlisting, :with_existing_work),
        "6" => attributes_for(:playlisting, :with_existing_work),
        "7" => attributes_for(:playlisting, :with_existing_work),
        "8" => attributes_for(:playlisting, :with_existing_work),
        "9" => attributes_for(:playlisting, :with_existing_work),
      } }
    end

    trait :with_10_viewable_tracks do
      playlistings_attributes { {
        "0" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "1" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "2" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "3" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "4" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "5" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "6" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "7" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "8" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
        "9" => attributes_for(:playlisting, :with_existing_work, :with_published_post),
      } }
    end

    trait :with_draft_post do
      after(:create) do |playlist|
        create(:mixtape, :draft, author_id: playlist.author.id, playlist_id: playlist.id)

        playlist.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |playlist|
        create(:mixtape, :scheduled, author_id: playlist.author.id, playlist_id: playlist.id)

        playlist.reload
      end
    end

    trait :with_published_post do
      after(:create) do |playlist|
        create(:mixtape, :published, author_id: playlist.author.id, playlist_id: playlist.id)

        playlist.reload
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

    factory :minimal_playlist do
      with_title
      with_existing_author
      with_2_tracks
    end

    factory :complete_playlist, parent: :minimal_playlist do
      with_10_viewable_tracks
    end
  end
end
