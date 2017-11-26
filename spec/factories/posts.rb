FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :naked_post_title do |n|
    "Naked Post Title #{n}"
  end

  sequence :album_post_title do |n|
    "Album Post Title #{n}"
  end

  sequence :song_post_title do |n|
    "Song Post Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :post do
    factory :naked_post do
      title { generate(:naked_post_title) }
      body "This is come content."

      factory :minimal_post do
        # Just a naked post.
      end
    end

    factory :song_post do
      title { generate(:song_post_title) }
      body "This is a song review."
      association :postable, factory: :minimal_song
    end

    factory :album_post do
      title { generate(:album_post_title) }
      body "This is an album review."
      association :postable, factory: :minimal_album
    end
  end
end
