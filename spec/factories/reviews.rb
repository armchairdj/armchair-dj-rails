FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :album_review_title do |n|
    "Album Review Title #{n}"
  end

  sequence :song_review_title do |n|
    "Song Review Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :review do
    factory :song_review do
      title { generate(:song_review_title) }
      association :reviewable, factory: :minimal_song

      factory :minimal_review do
        # Just a song review
      end
    end

    factory :album_review do
      title { generate(:album_review_title) }
      association :reviewable, factory: :minimal_album
    end
  end
end
