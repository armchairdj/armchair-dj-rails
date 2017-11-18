FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :song_title do |n|
    "Song Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :song do
    factory :minimal_song do
      association :artist, factory: :minimal_artist
      title { generate(:song_title) }
    end
  end
end
