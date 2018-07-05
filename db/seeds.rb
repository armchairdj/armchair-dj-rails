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
).find_or_create_by(email: "armchairdj@gmail.com") do |user|
  user.skip_confirmation!
end

##### ASPECTS

album_formats        = [
  FactoryBot.create(:aspect, facet: :album_format, name: "LP"),
  FactoryBot.create(:aspect, facet: :album_format, name: "EP"),
  FactoryBot.create(:aspect, facet: :album_format, name: "Single"),
  FactoryBot.create(:aspect, facet: :album_format, name: "Boxed Set"),
  FactoryBot.create(:aspect, facet: :album_format, name: "Download"),
]

audio_show_formats = [
  FactoryBot.create(:aspect, facet: :audio_show_format, name: "Interview"),
  FactoryBot.create(:aspect, facet: :audio_show_format, name: "Discussion"),
  FactoryBot.create(:aspect, facet: :audio_show_format, name: "Narrative"),
  FactoryBot.create(:aspect, facet: :audio_show_format, name: "Documentary"),
]

device_types       = [
  FactoryBot.create(:aspect, facet: :device_type, name: "Phone"),
  FactoryBot.create(:aspect, facet: :device_type, name: "Computer"),
  FactoryBot.create(:aspect, facet: :device_type, name: "Accessory"),
  FactoryBot.create(:aspect, facet: :device_type, name: "Router"),
]

game_mechanics     = [
  FactoryBot.create(:aspect, facet: :game_mechanic, name: "First-Person Shooter"),
  FactoryBot.create(:aspect, facet: :game_mechanic, name: "Couch Co-Op"),
  FactoryBot.create(:aspect, facet: :game_mechanic, name: "MMORPG"),
]

game_studios       = [
  FactoryBot.create(:aspect, facet: :game_studio, name: "Capcom"),
  FactoryBot.create(:aspect, facet: :game_studio, name: "Blizzard"),
]

hollywood_studios  = [
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Netflix"),
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Amazon"),
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Hulu"),
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Disney"),
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Fox"),
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Sony"),
  FactoryBot.create(:aspect, facet: :hollywood_studio, name: "Universal"),
]

manufacturers      = [
  FactoryBot.create(:aspect, facet: :manufacturer, name: "Unilever"),
  FactoryBot.create(:aspect, facet: :manufacturer, name: "Proctor & Gamble"),
  FactoryBot.create(:aspect, facet: :manufacturer, name: "Amazon Basics"),
  FactoryBot.create(:aspect, facet: :manufacturer, name: "Tom Bihn"),
  FactoryBot.create(:aspect, facet: :manufacturer, name: "The North Face"),
]

music_labels       = [
  FactoryBot.create(:aspect, facet: :music_label, name: "Warp"),
  FactoryBot.create(:aspect, facet: :music_label, name: "Soul Jazz"),
  FactoryBot.create(:aspect, facet: :music_label, name: "Plus 8"),
  FactoryBot.create(:aspect, facet: :music_label, name: "Planet E"),
  FactoryBot.create(:aspect, facet: :music_label, name: "Hyperdub"),
  FactoryBot.create(:aspect, facet: :music_label, name: "Island"),
]

musical_genres     = [
  FactoryBot.create(:aspect, facet: :musical_genre, name: "AOR"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Ambient"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Chamber Pop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Classic Rock"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Classical"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Dance-Pop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Disco"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Doom Metal"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Dream Pop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Drum-n-Bass"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Dub"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Easy Listening"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Electro"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Film & TV"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Hardcore"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Hip-Hop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "House"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "IDM"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Indie-Pop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Jazz"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Jungle"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Krautrock"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "MOR"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Musical"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Original Score"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Original Soundtrack"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Pop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "R&B"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Rap"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Reggae"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Rock"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Rock-'n'-Roll"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Soul"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Spoken Word"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Synth-Pop"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Synthwave"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Techno"),
  FactoryBot.create(:aspect, facet: :musical_genre, name: "Vocals"),
]

narrative_genres   = [
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Action"),
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Adventure"),
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Horror"),
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Sci-Fi"),
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Fantasy"),
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Comedy"),
  FactoryBot.create(:aspect, facet: :narrative_genre, name: "Drama"),
]

product_types      = [
  FactoryBot.create(:aspect, facet: :product_type, name: "Clothing"),
  FactoryBot.create(:aspect, facet: :product_type, name: "Moisturizer"),
  FactoryBot.create(:aspect, facet: :product_type, name: "Body Wash"),
]

publication_types  = [
  FactoryBot.create(:aspect, facet: :publication_type, name: "Magazine"),
  FactoryBot.create(:aspect, facet: :publication_type, name: "Newspaper"),
  FactoryBot.create(:aspect, facet: :publication_type, name: "Website"),
]

publishers         = [
  FactoryBot.create(:aspect, facet: :publisher, name: "Conde Nast"),
  FactoryBot.create(:aspect, facet: :publisher, name: "Vox Media"),
  FactoryBot.create(:aspect, facet: :publisher, name: "Marvel Comics"),
  FactoryBot.create(:aspect, facet: :publisher, name: "DC Comics"),
  FactoryBot.create(:aspect, facet: :publisher, name: "Vertigo"),
]

radio_networks     = [
  FactoryBot.create(:aspect, facet: :radio_network, name: "NPR"),
  FactoryBot.create(:aspect, facet: :radio_network, name: "PRI"),
  FactoryBot.create(:aspect, facet: :radio_network, name: "Sirius XM"),
]

song_types         = [
  FactoryBot.create(:aspect, facet: :song_type, name: "Studio"),
  FactoryBot.create(:aspect, facet: :song_type, name: "Remix"),
  FactoryBot.create(:aspect, facet: :song_type, name: "Live"),
]

tech_platforms      = [
  FactoryBot.create(:aspect, facet: :tech_platform, name: "iOS"),
  FactoryBot.create(:aspect, facet: :tech_platform, name: "macOS"),
  FactoryBot.create(:aspect, facet: :tech_platform, name: "PS4"),
  FactoryBot.create(:aspect, facet: :tech_platform, name: "Web"),
]

tv_networks        = [
  FactoryBot.create(:aspect, facet: :tv_network, name: "Fox"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "ABC"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "NBC"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "CBS"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "AMC"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "Netflix"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "Hulu"),
  FactoryBot.create(:aspect, facet: :tv_network, name: "Amazon"),
]

tech_companies     = [
  FactoryBot.create(:aspect, facet: :tech_company, name: "Rogue Amoeba"),
  FactoryBot.create(:aspect, facet: :tech_company, name: "Many Tricks"),
  FactoryBot.create(:aspect, facet: :tech_company, name: "Apple"),
  FactoryBot.create(:aspect, facet: :tech_company, name: "Google"),
  FactoryBot.create(:aspect, facet: :tech_company, name: "Facebook"),
  FactoryBot.create(:aspect, facet: :tech_company, name: "Amazon"),
]

##### ROLES

song_artist                = FactoryBot.create(:role, medium: "Song", name: "Artist")
song_featured_artist       = FactoryBot.create(:role, medium: "Song", name: "Featured Artist")
song_songwriter            = FactoryBot.create(:role, medium: "Song", name: "Songwriter")
song_lyricist              = FactoryBot.create(:role, medium: "Song", name: "Lyricist")
song_composer              = FactoryBot.create(:role, medium: "Song", name: "Composer")
song_producer              = FactoryBot.create(:role, medium: "Song", name: "Producer")
song_executive_producer    = FactoryBot.create(:role, medium: "Song", name: "Executive Producer")
song_co_producer           = FactoryBot.create(:role, medium: "Song", name: "Co-Producer")
song_engineer              = FactoryBot.create(:role, medium: "Song", name: "Engineer")
song_vocalist              = FactoryBot.create(:role, medium: "Song", name: "Vocalist")
song_backing_vocalist      = FactoryBot.create(:role, medium: "Song", name: "Backing Vocalist")
song_musician              = FactoryBot.create(:role, medium: "Song", name: "Musician")
song_remixer               = FactoryBot.create(:role, medium: "Song", name: "Remixer")

album_artist               = FactoryBot.create(:role, medium: "Album", name: "Artist")
album_featured_artist      = FactoryBot.create(:role, medium: "Album", name: "Featured Artist")
album_songwriter           = FactoryBot.create(:role, medium: "Album", name: "Songwriter")
album_lyricist             = FactoryBot.create(:role, medium: "Album", name: "Lyricist")
album_composer             = FactoryBot.create(:role, medium: "Album", name: "Composer")
album_producer             = FactoryBot.create(:role, medium: "Album", name: "Producer")
album_executive_producer   = FactoryBot.create(:role, medium: "Album", name: "Executive Producer")
album_co_producer          = FactoryBot.create(:role, medium: "Album", name: "Co-Producer")
album_engineer             = FactoryBot.create(:role, medium: "Album", name: "Engineer")
album_vocalist             = FactoryBot.create(:role, medium: "Album", name: "Vocalist")
album_backing_vocalist     = FactoryBot.create(:role, medium: "Album", name: "Backing Vocalist")
album_musician             = FactoryBot.create(:role, medium: "Album", name: "Musician")

movie_director             = FactoryBot.create(:role, medium: "Movie", name: "Director")
movie_producer             = FactoryBot.create(:role, medium: "Movie", name: "Producer")
movie_executive_producer   = FactoryBot.create(:role, medium: "Movie", name: "Executive Producer")
movie_co_producer          = FactoryBot.create(:role, medium: "Movie", name: "Co-Producer")
movie_cinematographer      = FactoryBot.create(:role, medium: "Movie", name: "Cinematographer")
movie_screenwriter         = FactoryBot.create(:role, medium: "Movie", name: "Screenwriter")
movie_film_editor          = FactoryBot.create(:role, medium: "Movie", name: "Film Editor")
movie_music_supervisor     = FactoryBot.create(:role, medium: "Movie", name: "Music Supervisor")
movie_composer             = FactoryBot.create(:role, medium: "Movie", name: "Composer")
movie_sound_editor         = FactoryBot.create(:role, medium: "Movie", name: "Sound Editor")
movie_sound_effects        = FactoryBot.create(:role, medium: "Movie", name: "Sound Effects")

tv_show_creator            = FactoryBot.create(:role, medium: "TvShow", name: "Creator")
tv_show_producer           = FactoryBot.create(:role, medium: "TvShow", name: "Producer")
tv_show_executive_producer = FactoryBot.create(:role, medium: "TvShow", name: "Executive Producer")
tv_show_co_producer        = FactoryBot.create(:role, medium: "TvShow", name: "Co-Producer")
tv_show_showrunner         = FactoryBot.create(:role, medium: "TvShow", name: "Showrunner")

tv_season_showrunner       = FactoryBot.create(:role, medium: "TvSeason", name: "Showrunner")

tv_episode_writer          = FactoryBot.create(:role, medium: "TvEpisode", name: "Writer")
tv_episode_director        = FactoryBot.create(:role, medium: "TvEpisode", name: "Director")
tv_episode_editor          = FactoryBot.create(:role, medium: "TvEpisode", name: "Film Editor")
tv_episode_composer        = FactoryBot.create(:role, medium: "TvEpisode", name: "Composer")

book_author                = FactoryBot.create(:role, medium: "Book", name: "Author")
book_editor                = FactoryBot.create(:role, medium: "Book", name: "Editor")
book_illustrator           = FactoryBot.create(:role, medium: "Book", name: "Illustrator")

comic_book_cartoonist      = FactoryBot.create(:role, medium: "ComicBook", name: "Cartoonist")
comic_book_writer          = FactoryBot.create(:role, medium: "ComicBook", name: "Writer")
comic_book_penciller       = FactoryBot.create(:role, medium: "ComicBook", name: "Penciller")
comic_book_inker           = FactoryBot.create(:role, medium: "ComicBook", name: "Inker")
comic_book_colorist        = FactoryBot.create(:role, medium: "ComicBook", name: "Colorist")
comic_book_letterer        = FactoryBot.create(:role, medium: "ComicBook", name: "Letterer")
comic_book_cover_artist    = FactoryBot.create(:role, medium: "ComicBook", name: "Cover Artist")

graphic_novel_cartoonist   = FactoryBot.create(:role, medium: "GraphicNovel", name: "Cartoonist")
graphic_novel_writer       = FactoryBot.create(:role, medium: "GraphicNovel", name: "Writer")
graphic_novel_penciller    = FactoryBot.create(:role, medium: "GraphicNovel", name: "Penciller")
graphic_novel_inker        = FactoryBot.create(:role, medium: "GraphicNovel", name: "Inker")
graphic_novel_colorist     = FactoryBot.create(:role, medium: "GraphicNovel", name: "Colorist")
graphic_novel_letterer     = FactoryBot.create(:role, medium: "GraphicNovel", name: "Letterer")
graphic_novel_cover_artist = FactoryBot.create(:role, medium: "GraphicNovel", name: "Cover Artist")

video_game_designer        = FactoryBot.create(:role, medium: "VideoGame", name: "Designer")
video_game_developer       = FactoryBot.create(:role, medium: "VideoGame", name: "Developer")

publication_writer         = FactoryBot.create(:role, medium: "Publication", name: "Writer")
publication_editor         = FactoryBot.create(:role, medium: "Publication", name: "Editor")
publication_publisher      = FactoryBot.create(:role, medium: "Publication", name: "Publisher")

app_programmer        = FactoryBot.create(:role, medium: "App", name: "Programmer")
app_designer          = FactoryBot.create(:role, medium: "App", name: "Designer")

gadget_designer          = FactoryBot.create(:role, medium: "Gadget", name: "Designer")

product_designer           = FactoryBot.create(:role, medium: "Product", name: "Designer")

radio_show_host            = FactoryBot.create(:role, medium: "RadioShow", name: "Host")
radio_show_producer        = FactoryBot.create(:role, medium: "RadioShow", name: "Producer")

podcast_host               = FactoryBot.create(:role, medium: "Podcast", name: "Host")
podcast_producer           = FactoryBot.create(:role, medium: "Podcast", name: "Producer")

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

kate_bush_album_tki                    = FactoryBot.create(:album, :with_milestone, title: "The Kick Inside",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_lh                     = FactoryBot.create(:album, :with_milestone, title: "Lionheart",         "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_nfe                    = FactoryBot.create(:album, :with_milestone, title: "Never for Ever",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_td                     = FactoryBot.create(:album, :with_milestone, title: "The Dreaming",      "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_hol                    = FactoryBot.create(:album, :with_milestone, title: "Never for Ever",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_tsw                    = FactoryBot.create(:album, :with_milestone, title: "The Sensual world", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_trs                    = FactoryBot.create(:album, :with_milestone, title: "The Red Shoes",     "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_aasoh                  = FactoryBot.create(:album, :with_milestone, title: "Aerial",            "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_dc                     = FactoryBot.create(:album, :with_milestone, title: "Director's Cut",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_fwfs                   = FactoryBot.create(:album, :with_milestone, title: "50 Words for Snow", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_btdl                   = FactoryBot.create(:album, :with_milestone, title: "Before the Dawn",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })

plastikman_album_sheet_one             = FactoryBot.create(:album, :with_milestone, title: "Sheet One",        "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_musik                 = FactoryBot.create(:album, :with_milestone, title: "Musik",            "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_recycled_plastik      = FactoryBot.create(:album, :with_milestone, title: "Recycled Plastik", "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_consumed              = FactoryBot.create(:album, :with_milestone, title: "Consumed",         "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_artifakts             = FactoryBot.create(:album, :with_milestone, title: "Artifakts (BC)",   "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_closer                = FactoryBot.create(:album, :with_milestone, title: "Closer",           "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_ex                    = FactoryBot.create(:album, :with_milestone, title: "EX",               "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

plastikman_song_hump                   = FactoryBot.create(:song, :with_milestone, title: "Hump",               "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_song_plastique              = FactoryBot.create(:song, :with_milestone, title: "Plastique",          "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

fleetwood_mac_album_fleetwood_mac      = FactoryBot.create(:album, :with_milestone, title: "Fleetwood Mac",      "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_rumors             = FactoryBot.create(:album, :with_milestone, title: "Rumors",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tusk               = FactoryBot.create(:album, :with_milestone, title: "Tusk",               "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_mirage             = FactoryBot.create(:album, :with_milestone, title: "Mirage",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tango_in_the_night = FactoryBot.create(:album, :with_milestone, title: "Tango in the Night", "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

fleetwood_mac_song_little_lies         = FactoryBot.create(:song, :with_milestone, title: "Little Lies",         "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dreams              = FactoryBot.create(:song, :with_milestone, title: "Dreams",              "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dont_stop           = FactoryBot.create(:song, :with_milestone, title: "Don't Stop",          "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_gold_dust_woman     = FactoryBot.create(:song, :with_milestone, title: "Gold Dust Woman",     "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

spawn_song_hammerknock                 = FactoryBot.create(:song, :with_milestone, title: "Hammerknock",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_tension                     = FactoryBot.create(:song, :with_milestone, title: "Tension",          "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltrator                 = FactoryBot.create(:song, :with_milestone, title: "Infiltrator",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltration                = FactoryBot.create(:song, :with_milestone, title: "Infiltration",     "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_the_thinking_man            = FactoryBot.create(:song, :with_milestone, title: "The Thinking Man", "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })

the_kooky_scientist_album_unpopular_science = FactoryBot.create(:album, :with_milestone, title: "Unpopular Science", "credits_attributes" => { "0" => { "creator_id" => the_kooky_scientist.id } })

##### POSTS: REVIEWS & STANDALONE

20.times { FactoryBot.create(:minimal_article, random_status, author: brian, body: random_paragraphs, title: random_title) }

10.times { FactoryBot.create(:complete_mixtape, :published) }

Work.all.each do |work|
  FactoryBot.create(:minimal_review, random_status, author: brian, body: random_paragraphs, work: work)
end
