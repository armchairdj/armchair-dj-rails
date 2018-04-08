require 'ffaker'

FactoryBot.define do
  factory :work do
    factory :minimal_work, parent: :song do; end

    factory :work_for_contribution_factory do
      medium :song
      title  FFaker::Music.unique.song
    end

    ###########################################################################
    # SONGS.
    ###########################################################################

    factory :song do
      medium :song
      title  FFaker::Music.unique.song

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id)
      } }
    end

    factory :collaborative_song do
      medium :song
      title  FFaker::Music.unique.song

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id)
      } }
    end

    ###########################################################################
    # ALBUMS.
    ###########################################################################

    factory :album do
      medium :album
      title  FFaker::Music.unique.album

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id)
      } }
    end

    factory :collaborative_album do
      medium :album
      title  FFaker::Music.unique.album

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id)
      } }
    end

    ###########################################################################
    # FILMS.
    ###########################################################################

    factory :film do
      medium :film
      title  FFaker::Movie.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:director).id)
      } }
    end

    factory :collaborative_film do
      medium :film
      title  FFaker::Movie.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:director).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:director).id)
      } }
    end

    ###########################################################################
    # TV SHOWS.
    ###########################################################################

    factory :tv_show do
      medium :tv_show
      title  FFaker::Movie.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:showrunner).id)
      } }
    end

    factory :collaborative_tv_show do
      medium :tv_show
      title  FFaker::Movie.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:showrunner).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:showrunner).id)
      } }
    end

    ###########################################################################
    # BOOKS.
    ###########################################################################

    factory :book do
      medium :book
      title  FFaker::Book.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:author).id)
      } }
    end

    factory :collaborative_book do
      medium :book
      title  FFaker::Book.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:author).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:author).id)
      } }
    end

    ###########################################################################
    # COMICS.
    ###########################################################################

    factory :comic do
      medium :comic
      title  FFaker::Book.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:cartoonist).id)
      } }
    end

    factory :collaborative_comic do
      medium :comic
      title  FFaker::Book.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:cartoonist).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:cartoonist).id)
      } }
    end

    ###########################################################################
    # ARTWORKS.
    ###########################################################################

    factory :artwork do
      medium :artwork
      title  FFaker::CheesyLingo.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:artist).id)
      } }
    end

    factory :collaborative_artwork do
      medium :artwork
      title  FFaker::CheesyLingo.unique.title

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:artist).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:artist).id)
      } }
    end

    ###########################################################################
    # SOFTWARE.
    ###########################################################################

    factory :software do
      medium :software
      title  FFaker::Product.unique.brand

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:programmer).id)
      } }
    end

    factory :collaborative_software do
      medium :software
      title  FFaker::Product.unique.brand

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:programmer).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:programmer).id)
      } }
    end

    ###########################################################################
    # SPECIFIC WORKS.
    ###########################################################################

    factory :green_velvet_and_carl_craig_unity do
      medium :album
      title  "Unity"

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator, name: "Green Velvet").id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator, name: "Carl Craig"  ).id)
      } }
    end

    factory :kate_bush_hounds_of_love do
      medium :album
      title "Hounds of Love"

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator, name: "Kate Bush").id),
      } }
    end

    factory :madonna_ray_of_light do
      medium :album
      title  "Ray of Light"

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator,        creator_id: create(:minimal_creator, name: "Madonna"      ).id),
        "1" => attributes_for(:contribution, role: :music_producer, creator_id: create(:minimal_creator, name: "William Orbit").id),
      } }
    end
  end
end
