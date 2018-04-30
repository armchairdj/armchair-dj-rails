# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :work do
    factory :minimal_work, parent: :song do; end

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_subtitle do
      subtitle "Subtitle"
    end

    trait :with_version do
      subtitle "Version"
    end

    trait :with_contribution do
      contributions_attributes { {
        "0" => attributes_for(:minimal_contribution, creator_id: create(:minimal_creator).id),
      } }
    end

    trait :with_draft_post do
      after(:create) do |work|
        create(:song_review, :draft, work_id: work.id)

        work.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |work|
        create(:song_review, :scheduled, work_id: work.id)

        work.reload
      end
    end

    trait :with_published_post do
      after(:create) do |work|
        create(:song_review, :published, work_id: work.id)

        work.reload
      end
    end

    trait :with_one_of_each_post_status do
      after(:create) do |work|
        create(:song_review, :draft,     work_id: work.id)
        create(:song_review, :scheduled, work_id: work.id)
        create(:song_review, :published, work_id: work.id)

        work.reload
      end
    end

    ###########################################################################
    # STUBS FOR OTHER FACTORIES.
    ###########################################################################

    factory :work_without_credits do
      medium :song
      title  { FFaker::Music.song }
    end

    ###########################################################################
    # SONGS.
    ###########################################################################

    factory :song do
      medium :song
      title  { FFaker::Music.song }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:musician).id)
      } }
    end

    factory :collaborative_song do
      medium :song
      title  { FFaker::Music.song }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:musician).id),
        "1" => attributes_for(:credit, creator_id: create(:musician).id)
      } }
    end

    factory :remix do
      medium   :song
      title    { FFaker::Music.song }
      subtitle "C2 Remix"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:musician).id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :remixer, creator_id: create(:musician).id)
      } }
    end

    ###########################################################################
    # ALBUMS.
    ###########################################################################

    factory :album do
      medium :album
      title  { FFaker::Music.album }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:musician).id)
      } }
    end

    factory :collaborative_album do
      medium :album
      title  { FFaker::Music.album }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:musician).id),
        "1" => attributes_for(:credit, creator_id: create(:musician).id)
      } }
    end

    factory :special_edition_album do
      medium   :album
      title    { FFaker::Music.album }
      subtitle "Special Edition"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:musician).id)
      } }
    end

    ###########################################################################
    # FILMS.
    ###########################################################################

    factory :movie do
      medium :movie
      title  { FFaker::Movie.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:director).id)
      } }
    end

    factory :collaborative_movie do
      medium :movie
      title  { FFaker::Movie.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:director).id),
        "1" => attributes_for(:credit, creator_id: create(:director).id)
      } }
    end

    factory :directors_cut_movie do
      medium   :movie
      title    { FFaker::Movie.title }
      subtitle "Director's Cut"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:director).id)
      } }
    end

    ###########################################################################
    # TV SHOWS.
    ###########################################################################

    factory :tv_show do
      medium :tv_show
      title  { FFaker::Movie.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:showrunner).id)
      } }
    end

    factory :collaborative_tv_show do
      medium :tv_show
      title  { FFaker::Movie.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:showrunner).id),
        "1" => attributes_for(:credit, creator_id: create(:showrunner).id)
      } }
    end

    ###########################################################################
    # RADIO SHOWS.
    ###########################################################################

    factory :radio_show do
      medium :radio_show
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:radio_host).id)
      } }
    end

    factory :collaborative_radio_show do
      medium :radio_show
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:radio_host).id),
        "1" => attributes_for(:credit, creator_id: create(:radio_host).id)
      } }
    end

    ###########################################################################
    # PODCASTS.
    ###########################################################################

    factory :podcast do
      medium :podcast
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:podcaster).id)
      } }
    end

    factory :collaborative_podcast do
      medium :podcast
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:podcaster).id),
        "1" => attributes_for(:credit, creator_id: create(:podcaster).id)
      } }
    end

    ###########################################################################
    # BOOKS.
    ###########################################################################

    factory :book do
      medium :book
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:author).id)
      } }
    end

    factory :memoir do
      medium   :book
      title    { FFaker::Book.title }
      subtitle "A Memoir"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:author).id)
      } }
    end

    factory :collaborative_book do
      medium :book
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:author).id),
        "1" => attributes_for(:credit, creator_id: create(:author).id)
      } }
    end

    ###########################################################################
    # COMICS.
    ###########################################################################

    factory :comic do
      medium :comic
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:cartoonist).id)
      } }
    end

    factory :collaborative_comic do
      medium :comic
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:cartoonist).id),
        "1" => attributes_for(:credit, creator_id: create(:cartoonist).id)
      } }
    end

    ###########################################################################
    # NEWSPAPERS.
    ###########################################################################

    factory :newspaper do
      medium :newspaper
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:publisher).id)
      } }
    end

    factory :collaborative_newspaper do
      medium :newspaper
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:publisher).id),
        "1" => attributes_for(:credit, creator_id: create(:publisher).id)
      } }
    end

    ###########################################################################
    # MAGAZINES.
    ###########################################################################

    factory :magazine do
      medium :magazine
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:publisher).id)
      } }
    end

    factory :collaborative_magazine do
      medium :magazine
      title  { FFaker::Book.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:publisher).id),
        "1" => attributes_for(:credit, creator_id: create(:publisher).id)
      } }
    end

    ###########################################################################
    # ARTWORKS.
    ###########################################################################

    factory :artwork do
      medium :artwork
      title  { FFaker::CheesyLingo.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:artist).id)
      } }
    end

    factory :collaborative_artwork do
      medium :artwork
      title  { FFaker::CheesyLingo.title }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:artist).id),
        "1" => attributes_for(:credit, creator_id: create(:artist).id)
      } }
    end

    ###########################################################################
    # GAMES.
    ###########################################################################

    factory :game do
      medium :game
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:game_platform).id)
      } }
    end

    factory :collaborative_game do
      medium :game
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:game_platform).id),
        "1" => attributes_for(:credit, creator_id: create(:game_platform).id)
      } }
    end

    ###########################################################################
    # SOFTWARE.
    ###########################################################################

    factory :software do
      medium :software
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:software_platform).id)
      } }
    end

    factory :collaborative_software do
      medium :software
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:software_platform).id),
        "1" => attributes_for(:credit, creator_id: create(:software_platform).id)
      } }
    end

    ###########################################################################
    # HARDWARE.
    ###########################################################################

    factory :hardware do
      medium :hardware
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:hardware_company).id)
      } }
    end

    factory :collaborative_hardware do
      medium :hardware
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:hardware_company).id),
        "1" => attributes_for(:credit, creator_id: create(:hardware_company).id)
      } }
    end

    ###########################################################################
    # PRODUCT.
    ###########################################################################

    factory :product do
      medium :product
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:brand).id)
      } }
    end

    factory :collaborative_product do
      medium :product
      title  { FFaker::Product.product_name }

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:brand).id),
        "1" => attributes_for(:credit, creator_id: create(:brand).id)
      } }
    end

    ###########################################################################
    # SPECIFIC WORKS.
    ###########################################################################

    factory :global_communications_76_14 do
      medium :album
      title  "76:14"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Global Communication").id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :music_producer, creator_id: create(:minimal_creator, name: "Tom Middleton" ).id),
        "1" => attributes_for(:contribution, role: :music_producer, creator_id: create(:minimal_creator, name: "Mark Pritchard").id)
      } }
    end

    factory :carl_craig_and_green_velvet_unity do
      medium :album
      title  "Unity"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Green Velvet").id),
        "1" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Carl Craig"  ).id)
      } }
    end

    factory :kate_bush_hounds_of_love do
      medium :album
      title "Hounds of Love"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:kate_bush).id),
      } }
    end

    factory :kate_bush_directors_cut do
      medium :album
      title "Director's Cut"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:kate_bush).id),
      } }
    end

    factory :madonna_ray_of_light do
      medium :album
      title  "Ray of Light"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Madonna").id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :music_producer, creator_id: create(:minimal_creator, name: "William Orbit").id),
      } }
    end

    factory :junior_boys_like_a_child_c2_remix do
      medium :song
      title "Like a Child"
      subtitle "C2 Remix"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Junior Boys").id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :remixer, creator_id: create(:minimal_creator, name: "Carl Craig" ).id),
      } }
    end
  end
end
