require "ffaker"

def self.random_paragraphs
  count = rand(1..18)
  FFaker::HipsterIpsum.paragraphs(count).join("\n\n")
end

def self.random_status
  [:published, :scheduled, :draft].sample
end

def self.random_title
  FFaker::HipsterIpsum.phrase.titleize
end

##### USERS

brian = User.create_with(
  role:        :root,
  username:    "armchairdj",
  first_name:  "Brian",
  middle_name: "J.",
  last_name:   "Dillard",
  password:    "password1234"
).find_or_create_by(email: "armchairdj@gmail.com")

brian.skip_confirmation!

##### ASPECTS

album_types        = [
  FactoryBot.create(:aspect, characteristic: :album_type, name: "LP"),
  FactoryBot.create(:aspect, characteristic: :album_type, name: "EP"),
  FactoryBot.create(:aspect, characteristic: :album_type, name: "Single"),
  FactoryBot.create(:aspect, characteristic: :album_type, name: "Boxed Set"),
  FactoryBot.create(:aspect, characteristic: :album_type, name: "Download"),
]

audio_show_formats = [
  FactoryBot.create(:aspect, characteristic: :audio_show_format, name: "Interview"),
  FactoryBot.create(:aspect, characteristic: :audio_show_format, name: "Discussion"),
  FactoryBot.create(:aspect, characteristic: :audio_show_format, name: "Narrative"),
  FactoryBot.create(:aspect, characteristic: :audio_show_format, name: "Documentary"),
]

device_types       = [
  FactoryBot.create(:aspect, characteristic: :device_type, name: "Phone"),
  FactoryBot.create(:aspect, characteristic: :device_type, name: "Computer"),
  FactoryBot.create(:aspect, characteristic: :device_type, name: "Accessory"),
  FactoryBot.create(:aspect, characteristic: :device_type, name: "Router"),
]

game_mechanics     = [
  FactoryBot.create(:aspect, characteristic: :game_mechanic, name: "First-Person Shooter"),
  FactoryBot.create(:aspect, characteristic: :game_mechanic, name: "Couch Co-Op"),
  FactoryBot.create(:aspect, characteristic: :game_mechanic, name: "MMORPG"),
]

game_studios       = [
  FactoryBot.create(:aspect, characteristic: :game_studio, name: "Capcom"),
  FactoryBot.create(:aspect, characteristic: :game_studio, name: "Blizzard"),
]

hollywood_studios  = [
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Netflix"),
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Amazon"),
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Hulu"),
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Disney"),
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Fox"),
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Sony"),
  FactoryBot.create(:aspect, characteristic: :hollywood_studio, name: "Universal"),
]

manufacturers      = [
  FactoryBot.create(:aspect, characteristic: :manufacturer, name: "Unilever"),
  FactoryBot.create(:aspect, characteristic: :manufacturer, name: "Proctor & Gamble"),
  FactoryBot.create(:aspect, characteristic: :manufacturer, name: "Amazon Basics"),
  FactoryBot.create(:aspect, characteristic: :manufacturer, name: "Tom Bihn"),
  FactoryBot.create(:aspect, characteristic: :manufacturer, name: "The North Face"),
]

music_labels       = [
  FactoryBot.create(:aspect, characteristic: :music_label, name: "Warp"),
  FactoryBot.create(:aspect, characteristic: :music_label, name: "Soul Jazz"),
  FactoryBot.create(:aspect, characteristic: :music_label, name: "Plus 8"),
  FactoryBot.create(:aspect, characteristic: :music_label, name: "Planet E"),
  FactoryBot.create(:aspect, characteristic: :music_label, name: "Hyperdub"),
  FactoryBot.create(:aspect, characteristic: :music_label, name: "Island"),
]

musical_genres     = [
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "AOR"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Ambient"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Chamber Pop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Classic Rock"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Classical"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Dance-Pop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Disco"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Doom Metal"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Dream Pop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Drum-n-Bass"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Dub"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Easy Listening"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Electro"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Film & TV"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Hardcore"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Hip-Hop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "House"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "IDM"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Indie-Pop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Jazz"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Jungle"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Krautrock"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "MOR"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Musical"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Original Score"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Original Soundtrack"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Pop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "R&B"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Rap"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Reggae"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Rock"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Rock-'n'-Roll"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Soul"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Spoken Word"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Synth-Pop"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Synthwave"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Techno"),
  FactoryBot.create(:aspect, characteristic: :musical_genre, name: "Vocals"),
]

narrative_genres   = [
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Action"),
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Adventure"),
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Horror"),
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Sci-Fi"),
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Fantasy"),
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Comedy"),
  FactoryBot.create(:aspect, characteristic: :narrative_genre, name: "Drama"),
]

podcast_networks   = [
  FactoryBot.create(:aspect, characteristic: :podcast_network, name: "Maximum Fun"),
  FactoryBot.create(:aspect, characteristic: :podcast_network, name: "Planet Broadcasting"),
  FactoryBot.create(:aspect, characteristic: :podcast_network, name: "Relay.fm"),
  FactoryBot.create(:aspect, characteristic: :podcast_network, name: "5by5"),
]

product_types      = [
  FactoryBot.create(:aspect, characteristic: :product_type, name: "Clothing"),
  FactoryBot.create(:aspect, characteristic: :product_type, name: "Moisturizer"),
  FactoryBot.create(:aspect, characteristic: :product_type, name: "Body Wash"),
]

publication_types  = [
  FactoryBot.create(:aspect, characteristic: :publication_type, name: "Magazine"),
  FactoryBot.create(:aspect, characteristic: :publication_type, name: "Newspaper"),
  FactoryBot.create(:aspect, characteristic: :publication_type, name: "Website"),
]

publishers         = [
  FactoryBot.create(:aspect, characteristic: :publisher, name: "Conde Nast"),
  FactoryBot.create(:aspect, characteristic: :publisher, name: "Vox Media"),
  FactoryBot.create(:aspect, characteristic: :publisher, name: "Marvel Comics"),
  FactoryBot.create(:aspect, characteristic: :publisher, name: "DC Comics"),
  FactoryBot.create(:aspect, characteristic: :publisher, name: "Vertigo"),
]

radio_networks     = [
  FactoryBot.create(:aspect, characteristic: :radio_network, name: "NPR"),
  FactoryBot.create(:aspect, characteristic: :radio_network, name: "PRI"),
  FactoryBot.create(:aspect, characteristic: :radio_network, name: "Sirius XM"),
]

song_types         = [
  FactoryBot.create(:aspect, characteristic: :song_type, name: "Studio"),
  FactoryBot.create(:aspect, characteristic: :song_type, name: "Remix"),
  FactoryBot.create(:aspect, characteristic: :song_type, name: "Live"),
]

tech_platforms      = [
  FactoryBot.create(:aspect, characteristic: :tech_platform, name: "iOS"),
  FactoryBot.create(:aspect, characteristic: :tech_platform, name: "macOS"),
  FactoryBot.create(:aspect, characteristic: :tech_platform, name: "PS4"),
  FactoryBot.create(:aspect, characteristic: :tech_platform, name: "Web"),
]

tv_networks        = [
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "Fox"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "ABC"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "NBC"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "CBS"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "AMC"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "Netflix"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "Hulu"),
  FactoryBot.create(:aspect, characteristic: :tv_network, name: "Amazon"),
]

tech_companies     = [
  FactoryBot.create(:aspect, characteristic: :tech_company, name: "Rogue Amoeba"),
  FactoryBot.create(:aspect, characteristic: :tech_company, name: "Many Tricks"),
  FactoryBot.create(:aspect, characteristic: :tech_company, name: "Apple"),
  FactoryBot.create(:aspect, characteristic: :tech_company, name: "Google"),
  FactoryBot.create(:aspect, characteristic: :tech_company, name: "Facebook"),
  FactoryBot.create(:aspect, characteristic: :tech_company, name: "Amazon"),
]

##### ROLES

song_artist                = FactoryBot.create(:role, work_type: "Song", name: "Artist")
song_featured_artist       = FactoryBot.create(:role, work_type: "Song", name: "Featured Artist")
song_songwriter            = FactoryBot.create(:role, work_type: "Song", name: "Songwriter")
song_lyricist              = FactoryBot.create(:role, work_type: "Song", name: "Lyricist")
song_composer              = FactoryBot.create(:role, work_type: "Song", name: "Composer")
song_producer              = FactoryBot.create(:role, work_type: "Song", name: "Producer")
song_executive_producer    = FactoryBot.create(:role, work_type: "Song", name: "Executive Producer")
song_co_producer           = FactoryBot.create(:role, work_type: "Song", name: "Co-Producer")
song_engineer              = FactoryBot.create(:role, work_type: "Song", name: "Engineer")
song_vocalist              = FactoryBot.create(:role, work_type: "Song", name: "Vocalist")
song_backing_vocalist      = FactoryBot.create(:role, work_type: "Song", name: "Backing Vocalist")
song_musician              = FactoryBot.create(:role, work_type: "Song", name: "Musician")
song_remixer               = FactoryBot.create(:role, work_type: "Song", name: "Remixer")

album_artist               = FactoryBot.create(:role, work_type: "Album", name: "Artist")
album_featured_artist      = FactoryBot.create(:role, work_type: "Album", name: "Featured Artist")
album_songwriter           = FactoryBot.create(:role, work_type: "Album", name: "Songwriter")
album_lyricist             = FactoryBot.create(:role, work_type: "Album", name: "Lyricist")
album_composer             = FactoryBot.create(:role, work_type: "Album", name: "Composer")
album_producer             = FactoryBot.create(:role, work_type: "Album", name: "Producer")
album_executive_producer   = FactoryBot.create(:role, work_type: "Album", name: "Executive Producer")
album_co_producer          = FactoryBot.create(:role, work_type: "Album", name: "Co-Producer")
album_engineer             = FactoryBot.create(:role, work_type: "Album", name: "Engineer")
album_vocalist             = FactoryBot.create(:role, work_type: "Album", name: "Vocalist")
album_backing_vocalist     = FactoryBot.create(:role, work_type: "Album", name: "Backing Vocalist")
album_musician             = FactoryBot.create(:role, work_type: "Album", name: "Musician")

movie_director             = FactoryBot.create(:role, work_type: "Movie", name: "Director")
movie_producer             = FactoryBot.create(:role, work_type: "Movie", name: "Producer")
movie_executive_producer   = FactoryBot.create(:role, work_type: "Movie", name: "Executive Producer")
movie_co_producer          = FactoryBot.create(:role, work_type: "Movie", name: "Co-Producer")
movie_cinematographer      = FactoryBot.create(:role, work_type: "Movie", name: "Cinematographer")
movie_screenwriter         = FactoryBot.create(:role, work_type: "Movie", name: "Screenwriter")
movie_film_editor          = FactoryBot.create(:role, work_type: "Movie", name: "Film Editor")
movie_music_supervisor     = FactoryBot.create(:role, work_type: "Movie", name: "Music Supervisor")
movie_composer             = FactoryBot.create(:role, work_type: "Movie", name: "Composer")
movie_sound_editor         = FactoryBot.create(:role, work_type: "Movie", name: "Sound Editor")
movie_sound_effects        = FactoryBot.create(:role, work_type: "Movie", name: "Sound Effects")

tv_show_creator            = FactoryBot.create(:role, work_type: "TvShow", name: "Creator")
tv_show_producer           = FactoryBot.create(:role, work_type: "TvShow", name: "Producer")
tv_show_executive_producer = FactoryBot.create(:role, work_type: "TvShow", name: "Executive Producer")
tv_show_co_producer        = FactoryBot.create(:role, work_type: "TvShow", name: "Co-Producer")
tv_show_showrunner         = FactoryBot.create(:role, work_type: "TvShow", name: "Showrunner")

tv_season_showrunner       = FactoryBot.create(:role, work_type: "TvSeason", name: "Showrunner")

tv_episode_writer          = FactoryBot.create(:role, work_type: "TvEpisode", name: "Writer")
tv_episode_director        = FactoryBot.create(:role, work_type: "TvEpisode", name: "Director")
tv_episode_editor          = FactoryBot.create(:role, work_type: "TvEpisode", name: "Film Editor")
tv_episode_composer        = FactoryBot.create(:role, work_type: "TvEpisode", name: "Composer")

book_author                = FactoryBot.create(:role, work_type: "Book", name: "Author")
book_editor                = FactoryBot.create(:role, work_type: "Book", name: "Editor")
book_illustrator           = FactoryBot.create(:role, work_type: "Book", name: "Illustrator")

comic_book_cartoonist      = FactoryBot.create(:role, work_type: "ComicBook", name: "Cartoonist")
comic_book_writer          = FactoryBot.create(:role, work_type: "ComicBook", name: "Writer")
comic_book_penciller       = FactoryBot.create(:role, work_type: "ComicBook", name: "Penciller")
comic_book_inker           = FactoryBot.create(:role, work_type: "ComicBook", name: "Inker")
comic_book_colorist        = FactoryBot.create(:role, work_type: "ComicBook", name: "Colorist")
comic_book_letterer        = FactoryBot.create(:role, work_type: "ComicBook", name: "Letterer")
comic_book_cover_artist    = FactoryBot.create(:role, work_type: "ComicBook", name: "Cover Artist")

graphic_novel_cartoonist   = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Cartoonist")
graphic_novel_writer       = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Writer")
graphic_novel_penciller    = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Penciller")
graphic_novel_inker        = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Inker")
graphic_novel_colorist     = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Colorist")
graphic_novel_letterer     = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Letterer")
graphic_novel_cover_artist = FactoryBot.create(:role, work_type: "GraphicNovel", name: "Cover Artist")

video_game_designer        = FactoryBot.create(:role, work_type: "VideoGame", name: "Designer")
video_game_developer       = FactoryBot.create(:role, work_type: "VideoGame", name: "Developer")

publication_writer         = FactoryBot.create(:role, work_type: "Publication", name: "Writer")
publication_editor         = FactoryBot.create(:role, work_type: "Publication", name: "Editor")
publication_publisher      = FactoryBot.create(:role, work_type: "Publication", name: "Publisher")

artwork_artist             = FactoryBot.create(:role, work_type: "Artwork", name: "Artist")

software_programmer        = FactoryBot.create(:role, work_type: "Software", name: "Programmer")
software_designer          = FactoryBot.create(:role, work_type: "Software", name: "Designer")

hardware_designer          = FactoryBot.create(:role, work_type: "Hardware", name: "Designer")

product_designer           = FactoryBot.create(:role, work_type: "Product", name: "Designer")

radio_show_host            = FactoryBot.create(:role, work_type: "RadioShow", name: "Host")
radio_show_producer        = FactoryBot.create(:role, work_type: "RadioShow", name: "Producer")

podcast_host               = FactoryBot.create(:role, work_type: "Podcast", name: "Host")
podcast_producer           = FactoryBot.create(:role, work_type: "Podcast", name: "Producer")

##### CREATORS, IDENTITIES & MEMBERSHIPS

fleetwood_mac       = FactoryBot.create(:fleetwood_mac_with_members)
wolfgang_voigt      = FactoryBot.create(:wolfgang_voigt_with_pseudonyms)
kate_bush           = FactoryBot.create(:kate_bush)
spawn_group         = FactoryBot.create(:complete_spawn)

plastikman          = Creator.find_by(name: "Plastikman")
fuse                = Creator.find_by(name: "F.U.S.E.")
the_kooky_scientist = Creator.find_by(name: "The Kooky Scientist")
gas                 = Creator.find_by(name: "Gas")

##### WORKS, CREDITS & CONTRIBUTIONS

kate_bush_album_tki                    = FactoryBot.create(:album, title: "The Kick Inside",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_lh                     = FactoryBot.create(:album, title: "Lionheart",         "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_nfe                    = FactoryBot.create(:album, title: "Never for Ever",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_td                     = FactoryBot.create(:album, title: "The Dreaming",      "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_hol                    = FactoryBot.create(:album, title: "Hounds of Love",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_tsw                    = FactoryBot.create(:album, title: "The Sensual world", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_trs                    = FactoryBot.create(:album, title: "The Red Shoes",     "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_aasoh                  = FactoryBot.create(:album, title: "Aerial",            "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_dc                     = FactoryBot.create(:album, title: "Director's Cut",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_fwfs                   = FactoryBot.create(:album, title: "50 Words for Snow", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_btdl                   = FactoryBot.create(:album, title: "Before the Dawn",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })

plastikman_album_sheet_one             = FactoryBot.create(:album, title: "Sheet One",        "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_musik                 = FactoryBot.create(:album, title: "Musik",            "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_recycled_plastik      = FactoryBot.create(:album, title: "Recycled Plastik", "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_consumed              = FactoryBot.create(:album, title: "Consumed",         "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_artifakts             = FactoryBot.create(:album, title: "Artifakts (BC)",   "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_closer                = FactoryBot.create(:album, title: "Closer",           "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_ex                    = FactoryBot.create(:album, title: "EX",               "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

plastikman_song_hump                   = FactoryBot.create(:song, title: "Hump",               "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_song_plastique              = FactoryBot.create(:song, title: "Plastique",          "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

fleetwood_mac_album_fleetwood_mac      = FactoryBot.create(:album, title: "Fleetwood Mac",      "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_rumors             = FactoryBot.create(:album, title: "Rumors",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tusk               = FactoryBot.create(:album, title: "Tusk",               "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_mirage             = FactoryBot.create(:album, title: "Mirage",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tango_in_the_night = FactoryBot.create(:album, title: "Tango in the Night", "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

fleetwood_mac_song_little_lies         = FactoryBot.create(:song, title: "Little Lies",         "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dreams              = FactoryBot.create(:song, title: "Dreams",              "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dont_stop           = FactoryBot.create(:song, title: "Don't Stop",          "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_gold_dust_woman     = FactoryBot.create(:song, title: "Gold Dust Woman",     "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

spawn_song_hammerknock                 = FactoryBot.create(:song, title: "Hammerknock",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_tension                     = FactoryBot.create(:song, title: "Tension",          "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltrator                 = FactoryBot.create(:song, title: "Infiltrator",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltration                = FactoryBot.create(:song, title: "Infiltration",     "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_the_thinking_man            = FactoryBot.create(:song, title: "The Thinking Man", "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })

the_kooky_scientist_album_unpopular_science = FactoryBot.create(:album, title: "Unpopular Science", "credits_attributes" => { "0" => { "creator_id" => the_kooky_scientist.id } })

##### POSTS: REVIEWS & STANDALONE

10.times { FactoryBot.create(:minimal_article, random_status, author: brian, body: random_paragraphs, title: random_title) }

5.times { FactoryBot.create(:complete_mixtape, :published) }

Work.all.each do |work|
  FactoryBot.create(:minimal_review, random_status, author: brian, body: random_paragraphs, work: work)
end
