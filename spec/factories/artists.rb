FactoryBot.define do
  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :artist_name do |n|
    "Artist Name #{n}"
  end

  factory :artist do
    factory :minimal_artist do
      name { generate(:artist_name) }
    end
  end
end
