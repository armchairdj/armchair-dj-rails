FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :album_title do |n|
    "Album Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :album do
    factory :minimal_album do
      title { generate(:album_title) }

      factory :single_artist_album do
        association :artist, factory: :minimal_artist
      end
    end
  end
end
