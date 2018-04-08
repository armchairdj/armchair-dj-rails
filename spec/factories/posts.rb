require 'ffaker'

FactoryBot.define do
  factory :post do
    factory :minimal_post, parent: :standalone_post do; end

    ###########################################################################
    # STANDALONE.
    ###########################################################################

    factory :standalone_post do
      title { FFaker::HipsterIpsum.phrase.titleize }
      body "This is a standalone post about, like, deep thoughts."
    end

    ###########################################################################
    # SONG REVIEWS.
    ###########################################################################

    factory :song_review do
      body "This is a song review."
      association :work, factory: :song
    end

    factory :collaborative_song_review do
      body "This is a song review."
      association :work, factory: :collaborative_song
    end

    ###########################################################################
    # ALBUM REVIEWS.
    ###########################################################################

    factory :album_review do
      body "This is an album review."
      association :work, factory: :album
    end

    factory :collaborative_album_review do
      body "This is an album review."
      association :work, factory: :collaborative_album
    end

    ###########################################################################
    # FILM REVIEWS.
    ###########################################################################

    factory :film_review do
      body "This is a film review."
      association :work, factory: :film
    end

    factory :collaborative_film_review do
      body "This is a film review."
      association :work, factory: :collaborative_film
    end

    ###########################################################################
    # TV SHOW REVIEWS.
    ###########################################################################

    factory :tv_show_review do
      body "This is a tv_show review."
      association :work, factory: :tv_show
    end

    factory :collaborative_tv_show_review do
      body "This is a tv_show review."
      association :work, factory: :collaborative_tv_show
    end

    ###########################################################################
    # BOOK REVIEWS.
    ###########################################################################

    factory :book_review do
      body "This is a book review."
      association :work, factory: :book
    end

    factory :collaborative_book_review do
      body "This is a book review."
      association :work, factory: :collaborative_book
    end

    ###########################################################################
    # COMIC REVIEWS.
    ###########################################################################

    factory :comic_review do
      body "This is a comic review."
      association :work, factory: :comic
    end

    factory :collaborative_comic_review do
      body "This is a comic review."
      association :work, factory: :collaborative_comic
    end

    ###########################################################################
    # ARTWORK REVIEWS.
    ###########################################################################

    factory :artwork_review do
      body "This is a artwork review."
      association :work, factory: :artwork
    end

    factory :collaborative_artwork_review do
      body "This is a artwork review."
      association :work, factory: :collaborative_artwork
    end

    ###########################################################################
    # SOFTWARE REVIEWS.
    ###########################################################################

    factory :software_review do
      body "This is a software review."
      association :work, factory: :software
    end

    factory :collaborative_software_review do
      body "This is a software review."
      association :work, factory: :collaborative_software
    end

    ###########################################################################
    # SPECIFIC WORKS.
    ###########################################################################

    factory :hounds_of_love_album_review do
      body "It's in the trees! It's coming!"
      association :work, factory: :kate_bush_hounds_of_love
    end
  end
end
