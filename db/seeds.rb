# frozen_string_literal: true

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
).find_or_create_by(email: "armchairdj@gmail.com", &:skip_confirmation!)

##### ASPECTS

album_formats = [
  FactoryBot.create(:aspect, key: :album_format, val: "LP"),
  FactoryBot.create(:aspect, key: :album_format, val: "EP"),
  FactoryBot.create(:aspect, key: :album_format, val: "Single"),
  FactoryBot.create(:aspect, key: :album_format, val: "Boxed Set"),
  FactoryBot.create(:aspect, key: :album_format, val: "Download")
]

audio_show_formats = [
  FactoryBot.create(:aspect, key: :audio_show_format, val: "Interview"),
  FactoryBot.create(:aspect, key: :audio_show_format, val: "Discussion"),
  FactoryBot.create(:aspect, key: :audio_show_format, val: "Narrative"),
  FactoryBot.create(:aspect, key: :audio_show_format, val: "Documentary")
]

device_types = [
  FactoryBot.create(:aspect, key: :device_type, val: "Phone"),
  FactoryBot.create(:aspect, key: :device_type, val: "Computer"),
  FactoryBot.create(:aspect, key: :device_type, val: "Accessory"),
  FactoryBot.create(:aspect, key: :device_type, val: "Router")
]

game_mechanics = [
  FactoryBot.create(:aspect, key: :game_mechanic, val: "First-Person Shooter"),
  FactoryBot.create(:aspect, key: :game_mechanic, val: "Couch Co-Op"),
  FactoryBot.create(:aspect, key: :game_mechanic, val: "MMORPG")
]

game_studios = [
  FactoryBot.create(:aspect, key: :game_studio, val: "Capcom"),
  FactoryBot.create(:aspect, key: :game_studio, val: "Blizzard")
]

hollywood_studios = [
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Netflix"),
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Amazon"),
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Hulu"),
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Disney"),
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Fox"),
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Sony"),
  FactoryBot.create(:aspect, key: :hollywood_studio, val: "Universal")
]

manufacturers = [
  FactoryBot.create(:aspect, key: :manufacturer, val: "Unilever"),
  FactoryBot.create(:aspect, key: :manufacturer, val: "Proctor & Gamble"),
  FactoryBot.create(:aspect, key: :manufacturer, val: "Amazon Basics"),
  FactoryBot.create(:aspect, key: :manufacturer, val: "Tom Bihn"),
  FactoryBot.create(:aspect, key: :manufacturer, val: "The North Face")
]

music_labels = [
  FactoryBot.create(:aspect, key: :music_label, val: "Warp"),
  FactoryBot.create(:aspect, key: :music_label, val: "Soul Jazz"),
  FactoryBot.create(:aspect, key: :music_label, val: "Plus 8"),
  FactoryBot.create(:aspect, key: :music_label, val: "Planet E"),
  FactoryBot.create(:aspect, key: :music_label, val: "Hyperdub"),
  FactoryBot.create(:aspect, key: :music_label, val: "Island")
]

musical_genres = [
  FactoryBot.create(:aspect, key: :musical_genre, val: "AOR"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Ambient"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Chamber Pop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Classic Rock"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Classical"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Dance-Pop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Disco"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Doom Metal"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Dream Pop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Drum-n-Bass"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Dub"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Easy Listening"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Electro"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Film & TV"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Hardcore"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Hip-Hop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "House"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "IDM"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Indie-Pop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Jazz"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Jungle"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Krautrock"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "MOR"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Musical"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Original Score"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Original Soundtrack"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Pop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "R&B"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Rap"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Reggae"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Rock"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Rock-'n'-Roll"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Soul"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Spoken Word"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Synth-Pop"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Synthwave"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Techno"),
  FactoryBot.create(:aspect, key: :musical_genre, val: "Vocals")
]

narrative_genres = [
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Action"),
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Adventure"),
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Horror"),
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Sci-Fi"),
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Fantasy"),
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Comedy"),
  FactoryBot.create(:aspect, key: :narrative_genre, val: "Drama")
]

product_types = [
  FactoryBot.create(:aspect, key: :product_type, val: "Clothing"),
  FactoryBot.create(:aspect, key: :product_type, val: "Moisturizer"),
  FactoryBot.create(:aspect, key: :product_type, val: "Body Wash")
]

publication_types = [
  FactoryBot.create(:aspect, key: :publication_type, val: "Magazine"),
  FactoryBot.create(:aspect, key: :publication_type, val: "Newspaper"),
  FactoryBot.create(:aspect, key: :publication_type, val: "Website")
]

publishers = [
  FactoryBot.create(:aspect, key: :publisher, val: "Conde Nast"),
  FactoryBot.create(:aspect, key: :publisher, val: "Vox Media"),
  FactoryBot.create(:aspect, key: :publisher, val: "Marvel Comics"),
  FactoryBot.create(:aspect, key: :publisher, val: "DC Comics"),
  FactoryBot.create(:aspect, key: :publisher, val: "Vertigo")
]

radio_networks = [
  FactoryBot.create(:aspect, key: :radio_network, val: "NPR"),
  FactoryBot.create(:aspect, key: :radio_network, val: "PRI"),
  FactoryBot.create(:aspect, key: :radio_network, val: "Sirius XM")
]

song_types = [
  FactoryBot.create(:aspect, key: :song_type, val: "Studio"),
  FactoryBot.create(:aspect, key: :song_type, val: "Remix"),
  FactoryBot.create(:aspect, key: :song_type, val: "Live")
]

tech_platforms = [
  FactoryBot.create(:aspect, key: :tech_platform, val: "iOS"),
  FactoryBot.create(:aspect, key: :tech_platform, val: "macOS"),
  FactoryBot.create(:aspect, key: :tech_platform, val: "PS4"),
  FactoryBot.create(:aspect, key: :tech_platform, val: "Web")
]

tv_networks = [
  FactoryBot.create(:aspect, key: :tv_network, val: "ABC"),
  FactoryBot.create(:aspect, key: :tv_network, val: "CBS"),
  FactoryBot.create(:aspect, key: :tv_network, val: "NBC"),
  FactoryBot.create(:aspect, key: :tv_network, val: "Fox"),
  FactoryBot.create(:aspect, key: :tv_network, val: "The WB"),
  FactoryBot.create(:aspect, key: :tv_network, val: "UPN"),
  FactoryBot.create(:aspect, key: :tv_network, val: "The CW"),

  FactoryBot.create(:aspect, key: :tv_network, val: "AMC"),
  FactoryBot.create(:aspect, key: :tv_network, val: "Lifetime"),
  FactoryBot.create(:aspect, key: :tv_network, val: "HBO"),
  FactoryBot.create(:aspect, key: :tv_network, val: "Cinemax"),
  FactoryBot.create(:aspect, key: :tv_network, val: "Showtime"),

  FactoryBot.create(:aspect, key: :tv_network, val: "Amazon"),
  FactoryBot.create(:aspect, key: :tv_network, val: "Hulu"),
  FactoryBot.create(:aspect, key: :tv_network, val: "Netflix")
]

tech_companies = [
  FactoryBot.create(:aspect, key: :tech_company, val: "Rogue Amoeba"),
  FactoryBot.create(:aspect, key: :tech_company, val: "Many Tricks"),
  FactoryBot.create(:aspect, key: :tech_company, val: "Apple"),
  FactoryBot.create(:aspect, key: :tech_company, val: "Google"),
  FactoryBot.create(:aspect, key: :tech_company, val: "Facebook"),
  FactoryBot.create(:aspect, key: :tech_company, val: "Amazon")
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

app_programmer             = FactoryBot.create(:role, medium: "App", name: "Programmer")
app_designer               = FactoryBot.create(:role, medium: "App", name: "Designer")

gadget_designer            = FactoryBot.create(:role, medium: "Gadget", name: "Designer")

product_designer           = FactoryBot.create(:role, medium: "Product", name: "Designer")

radio_show_host            = FactoryBot.create(:role, medium: "RadioShow", name: "Host")
radio_show_producer        = FactoryBot.create(:role, medium: "RadioShow", name: "Producer")

podcast_host               = FactoryBot.create(:role, medium: "Podcast", name: "Host")
podcast_producer           = FactoryBot.create(:role, medium: "Podcast", name: "Producer")

##### SONGS & ALBUMS

fleetwood_mac       = FactoryBot.create(:fleetwood_mac_with_members)
wolfgang_voigt      = FactoryBot.create(:wolfgang_voigt_with_pseudonyms)
kate_bush           = FactoryBot.create(:kate_bush)
spawn_group         = FactoryBot.create(:complete_spawn)

plastikman          = Creator.find_by(name: "Plastikman")
fuse                = Creator.find_by(name: "F.U.S.E.")
the_kooky_scientist = Creator.find_by(name: "The Kooky Scientist")
gas                 = Creator.find_by(name: "Gas")

kate_bush_album_tki                    = FactoryBot.create(:minimal_album, :with_specific_creator, title: "The Kick Inside",    specific_creator: kate_bush)
kate_bush_album_lh                     = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Lionheart",          specific_creator: kate_bush)
kate_bush_album_nfe                    = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Never for Ever",     specific_creator: kate_bush)
kate_bush_album_td                     = FactoryBot.create(:minimal_album, :with_specific_creator, title: "The Dreaming",       specific_creator: kate_bush)
kate_bush_album_hol                    = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Never for Ever",     specific_creator: kate_bush)
kate_bush_album_tsw                    = FactoryBot.create(:minimal_album, :with_specific_creator, title: "The Sensual world",  specific_creator: kate_bush)
kate_bush_album_trs                    = FactoryBot.create(:minimal_album, :with_specific_creator, title: "The Red Shoes",      specific_creator: kate_bush)
kate_bush_album_aasoh                  = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Aerial",             specific_creator: kate_bush)
kate_bush_album_dc                     = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Director's Cut",     specific_creator: kate_bush)
kate_bush_album_fwfs                   = FactoryBot.create(:minimal_album, :with_specific_creator, title: "50 Words for Snow",  specific_creator: kate_bush)
kate_bush_album_btdl                   = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Before the Dawn",    specific_creator: kate_bush)

plastikman_album_sheet_one             = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Sheet One",          specific_creator: plastikman)
plastikman_album_musik                 = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Musik",              specific_creator: plastikman)
plastikman_album_recycled_plastik      = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Recycled Plastik",   specific_creator: plastikman)
plastikman_album_consumed              = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Consumed",           specific_creator: plastikman)
plastikman_album_artifakts             = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Artifakts (BC)",     specific_creator: plastikman)
plastikman_album_closer                = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Closer",             specific_creator: plastikman)
plastikman_album_ex                    = FactoryBot.create(:minimal_album, :with_specific_creator, title: "EX",                 specific_creator: plastikman)

plastikman_song_hump                   = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Hump",              specific_creator: plastikman)
plastikman_song_plastique              = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Plastique",         specific_creator: plastikman)

fleetwood_mac_album_fleetwood_mac      = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Fleetwood Mac",      specific_creator: fleetwood_mac)
fleetwood_mac_album_rumors             = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Rumors",             specific_creator: fleetwood_mac)
fleetwood_mac_album_tusk               = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Tusk",               specific_creator: fleetwood_mac)
fleetwood_mac_album_mirage             = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Mirage",             specific_creator: fleetwood_mac)
fleetwood_mac_album_tango_in_the_night = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Tango in the Night", specific_creator: fleetwood_mac)

fleetwood_mac_song_little_lies         = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Little Lies",       specific_creator: fleetwood_mac)
fleetwood_mac_song_dreams              = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Dreams",            specific_creator: fleetwood_mac)
fleetwood_mac_song_dont_stop           = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Don't Stop",        specific_creator: fleetwood_mac)
fleetwood_mac_song_gold_dust_woman     = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Gold Dust Woman",   specific_creator: fleetwood_mac)

spawn_song_hammerknock                 = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Hammerknock",       specific_creator: spawn_group)
spawn_song_tension                     = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Tension",           specific_creator: spawn_group)
spawn_song_infiltrator                 = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Infiltrator",       specific_creator: spawn_group)
spawn_song_infiltration                = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "Infiltration",      specific_creator: spawn_group)
spawn_song_the_thinking_man            = FactoryBot.create(:minimal_song,  :with_specific_creator,  title: "The Thinking Man",  specific_creator: spawn_group)

kooky_album_unpopular_science          = FactoryBot.create(:minimal_album, :with_specific_creator, title: "Unpopular Science",  specific_creator: the_kooky_scientist)

##### TV

joss_whedon        = FactoryBot.create(:minimal_creator, name: "Joss Whedon")
buffy              = FactoryBot.create(:minimal_tv_show,    :with_specific_creator, release_year: "1997", title: "Buffy the Vampire Slayer",          specific_creator: joss_whedon)
buffy_season_seven = FactoryBot.create(:minimal_tv_season,  :with_specific_creator, release_year: "2002", title: "Buffy the Vampire Slayer Season 7", specific_creator: joss_whedon)
conversations      = FactoryBot.create(:minimal_tv_episode, :with_specific_creator, release_year: "2002", title: "Conversations With Dead People",    specific_creator: joss_whedon)

##### POSTS: REVIEWS & STANDALONE

20.times { FactoryBot.create(:minimal_article, random_status, author: brian, body: random_paragraphs, title: random_title) }

10.times { FactoryBot.create(:complete_mixtape, :published) }

Work.all.each do |work|
  FactoryBot.create(:minimal_review, random_status, author: brian, body: random_paragraphs, work: work)
end
