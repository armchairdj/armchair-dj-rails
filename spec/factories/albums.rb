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
    factory :single_artist_album do
      title { generate(:album_title) }
      association :artist, factory: :minimal_artist

      factory :minimal_album do
        # Just a single-artist album
      end
    end
  end
end
