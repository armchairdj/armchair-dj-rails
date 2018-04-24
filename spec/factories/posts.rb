require "ffaker"

FactoryBot.define do
  factory :post do
    factory :minimal_post, parent: :standalone_post do; end

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_user do
      association :user, factory: :admin
    end

    trait :draft do
      # default status is :draft
    end

    trait :scheduled do
      publish_on 3.weeks.from_now

      after(:create) do |post, evaluator|
        raise AASM::InvalidTransition unless post.schedule!

        post.reload
      end
    end

    trait :published do
      after(:create) do |post, evaluator|
        raise AASM::InvalidTransition unless post.publish!

        post.reload
      end
    end

    ###########################################################################
    # FOR OTHER FACTORIES.
    ###########################################################################

    factory :song_review_without_creators do
      with_user
      body        "This is a song review."
      association :work, factory: :work_without_contributions
    end

    ###########################################################################
    # STANDALONE.
    ###########################################################################

    factory :standalone_post do
      with_user
      title { FFaker::HipsterIpsum.phrase.titleize }
      body  "This is a standalone post about, like, deep thoughts."
    end

    ###########################################################################
    # SONG REVIEWS.
    ###########################################################################

    factory :song_review do
      with_user
      body        "This is a song review."
      association :work, factory: :song
    end

    factory :collaborative_song_review do
      with_user
      body        "This is a collaborative song review."
      association :work, factory: :collaborative_song
    end

    ###########################################################################
    # ALBUM REVIEWS.
    ###########################################################################

    factory :album_review do
      with_user
      body        "This is an album review."
      association :work, factory: :album
    end

    factory :collaborative_album_review do
      with_user
      body        "This is an album review."
      association :work, factory: :collaborative_album
    end

    ###########################################################################
    # MOVIE REVIEWS.
    ###########################################################################

    factory :movie_review do
      with_user
      body        "This is a movie review."
      association :work, factory: :movie
    end

    factory :collaborative_movie_review do
      with_user
      body        "This is a collaborative movie review."
      association :work, factory: :collaborative_movie
    end

    ###########################################################################
    # TV SHOW REVIEWS.
    ###########################################################################

    factory :tv_show_review do
      with_user
      body        "This is a tv_show review."
      association :work, factory: :tv_show
    end

    factory :collaborative_tv_show_review do
      with_user
      body        "This is a collaborative tv_show review."
      association :work, factory: :collaborative_tv_show
    end

    ###########################################################################
    # RADIO SHOW REVIEWS.
    ###########################################################################

    factory :radio_show_review do
      with_user
      body        "This is a radio_show review."
      association :work, factory: :radio_show
    end

    factory :collaborative_radio_show_review do
      with_user
      body        "This is a collaborative radio_show review."
      association :work, factory: :collaborative_radio_show
    end

    ###########################################################################
    # PODCAST REVIEWS.
    ###########################################################################

    factory :podcast_review do
      with_user
      body        "This is a podcast review."
      association :work, factory: :podcast
    end

    factory :collaborative_podcast_review do
      with_user
      body        "This is a collaborative podcast review."
      association :work, factory: :collaborative_podcast
    end

    ###########################################################################
    # BOOK REVIEWS.
    ###########################################################################

    factory :book_review do
      with_user
      body        "This is a book review."
      association :work, factory: :book
    end

    factory :collaborative_book_review do
      with_user
      body        "This is a collaborative book review."
      association :work, factory: :collaborative_book
    end

    ###########################################################################
    # COMIC REVIEWS.
    ###########################################################################

    factory :comic_review do
      with_user
      body        "This is a comic review."
      association :work, factory: :comic
    end

    factory :collaborative_comic_review do
      with_user
      body        "This is a collaborative comic review."
      association :work, factory: :collaborative_comic
    end

    ###########################################################################
    # NEWSPAPER REVIEWS.
    ###########################################################################

    factory :newspaper_review do
      with_user
      body        "This is a newspaper review."
      association :work, factory: :newspaper
    end

    factory :collaborative_newspaper_review do
      with_user
      body        "This is a collaborative newspaper review."
      association :work, factory: :collaborative_newspaper
    end

    ###########################################################################
    # MAGAZINE REVIEWS.
    ###########################################################################

    factory :magazine_review do
      with_user
      body        "This is a magazine review."
      association :work, factory: :magazine
    end

    factory :collaborative_magazine_review do
      with_user
      body        "This is a collaborative magazine review."
      association :work, factory: :collaborative_magazine
    end

    ###########################################################################
    # ARTWORK REVIEWS.
    ###########################################################################

    factory :artwork_review do
      with_user
      body        "This is a artwork review."
      association :work, factory: :artwork
    end

    factory :collaborative_artwork_review do
      with_user
      body        "This is a collaborative artwork review."
      association :work, factory: :collaborative_artwork
    end

    ###########################################################################
    # GAME REVIEWS.
    ###########################################################################

    factory :game_review do
      with_user
      body        "This is a game review."
      association :work, factory: :game
    end

    factory :collaborative_game_review do
      with_user
      body        "This is a collaborative game review."
      association :work, factory: :collaborative_game
    end

    ###########################################################################
    # SOFTWARE REVIEWS.
    ###########################################################################

    factory :software_review do
      with_user
      body        "This is a software review."
      association :work, factory: :software
    end

    factory :collaborative_software_review do
      with_user
      body        "This is a collaborative software review."
      association :work, factory: :collaborative_software
    end

    ###########################################################################
    # HARDWARE REVIEWS.
    ###########################################################################

    factory :hardware_review do
      with_user
      body        "This is a hardware review."
      association :work, factory: :hardware
    end

    factory :collaborative_hardware_review do
      with_user
      body        "This is a collaborative hardware review."
      association :work, factory: :collaborative_hardware
    end

    ###########################################################################
    # PRODUCT REVIEWS.
    ###########################################################################

    factory :product_review do
      with_user
      body        "This is a product review."
      association :work, factory: :product
    end

    factory :collaborative_product_review do
      with_user
      body        "This is a collaborative product review."
      association :work, factory: :collaborative_product
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :hounds_of_love_album_review, parent: :album_review do
      body        "It's in the trees! It's coming!"
      association :work, factory: :kate_bush_hounds_of_love
    end

    factory :unity_album_review, parent: :album_review do
      body        "All those little pills! You are my angel!"
      association :work, factory: :carl_craig_and_green_velvet_unity
    end

    factory :tiny_standalone_post, parent: :standalone_post do
      title "Hello"
      body  "It me."
    end
  end
end
