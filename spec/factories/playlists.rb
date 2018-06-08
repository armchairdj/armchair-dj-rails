FactoryBot.define do
  factory :playlist do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_title do
      title { FFaker::HipsterIpsum.phrase.titleize }
    end

    trait :with_author do
      association :author, factory: :admin
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
        "0" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "1" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "2" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "3" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "4" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "5" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "6" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "7" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "8" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
        "9" => attributes_for(:playlisting, :with_existing_work, :with_published_publication),
      } }
    end

    trait :with_draft_publication do
      after(:create) do |playlist|
        create(:mixtape, :draft, :with_body, author_id: playlist.author.id, playlist_id: playlist.id)

        playlist.reload
      end
    end

    trait :with_scheduled_publication do
      after(:create) do |playlist|
        create(:mixtape, :scheduled, :with_body, author_id: playlist.author.id, playlist_id: playlist.id)

        playlist.reload
      end
    end

    trait :with_published_publication do
      after(:create) do |playlist|
        create(:mixtape, :published, :with_body, author_id: playlist.author.id, playlist_id: playlist.id)

        playlist.reload
      end
    end

    trait :with_one_of_each_publication_status do
      with_draft_publication
      with_scheduled_publication
      with_published_publication
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_playlist do
      with_title
      with_author
      with_2_tracks
    end

    factory :complete_playlist, parent: :minimal_playlist do
      with_10_viewable_tracks
    end
  end
end
