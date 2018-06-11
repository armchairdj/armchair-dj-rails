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

##### MEDIA

song          = FactoryBot.create(:medium, :skip_validation, name: "Song"         )
album         = FactoryBot.create(:medium, :skip_validation, name: "Album"        )
movie         = FactoryBot.create(:medium, :skip_validation, name: "Movie"        )
tv_show       = FactoryBot.create(:medium, :skip_validation, name: "TV Show"      )
tv_season     = FactoryBot.create(:medium, :skip_validation, name: "TV Season"    )
tv_episode    = FactoryBot.create(:medium, :skip_validation, name: "TV Episode"   )
book          = FactoryBot.create(:medium, :skip_validation, name: "Book"         )
comic_book    = FactoryBot.create(:medium, :skip_validation, name: "Comic Book"   )
graphic_novel = FactoryBot.create(:medium, :skip_validation, name: "Graphic Novel")
video_game    = FactoryBot.create(:medium, :skip_validation, name: "Video Game"   )
publication   = FactoryBot.create(:medium, :skip_validation, name: "Publication"  )
artwork       = FactoryBot.create(:medium, :skip_validation, name: "Artwork"      )
software      = FactoryBot.create(:medium, :skip_validation, name: "Software"     )
hardware      = FactoryBot.create(:medium, :skip_validation, name: "Hardware"     )
product       = FactoryBot.create(:medium, :skip_validation, name: "Product"      )
radio_show    = FactoryBot.create(:medium, :skip_validation, name: "Radio Show"   )
podcast       = FactoryBot.create(:medium, :skip_validation, name: "Podcast"      )

##### CATEGORIES & TAGS

album_type         = FactoryBot.create(:category, name: "Album Type")
album_types        = [
                       FactoryBot.create(:aspect, category: album_type, name: "LP"),
                       FactoryBot.create(:aspect, category: album_type, name: "EP"),
                       FactoryBot.create(:aspect, category: album_type, name: "Single"),
                       FactoryBot.create(:aspect, category: album_type, name: "Boxed Set"),
                       FactoryBot.create(:aspect, category: album_type, name: "Download"),
                     ]

art_medium         = FactoryBot.create(:category, name: "Artistic Medium")
art_media          = [
                       FactoryBot.create(:aspect, category: art_medium, name: "Painting"),
                       FactoryBot.create(:aspect, category: art_medium, name: "Sculpture"),
                       FactoryBot.create(:aspect, category: art_medium, name: "Photography"),
                       FactoryBot.create(:aspect, category: art_medium, name: "Mixed Media"),
                     ]

art_movement       = FactoryBot.create(:category, name: "Artistic Movement")
art_movements      = [
                       FactoryBot.create(:aspect, category: art_movement, name: "Pop Art"),
                       FactoryBot.create(:aspect, category: art_movement, name: "Articlemodernism"),
                       FactoryBot.create(:aspect, category: art_movement, name: "Modernism"),
                     ]

audio_show_format  = FactoryBot.create(:category, name: "Audio Show Format")
audio_show_formats = [
                       FactoryBot.create(:aspect, category: audio_show_format, name: "Interview"),
                       FactoryBot.create(:aspect, category: audio_show_format, name: "Discussion"),
                       FactoryBot.create(:aspect, category: audio_show_format, name: "Narrative"),
                       FactoryBot.create(:aspect, category: audio_show_format, name: "Documentary"),
                     ]

device_type        = FactoryBot.create(:category, name: "Device Type")
device_types       = [
                       FactoryBot.create(:aspect, category: device_type, name: "Phone"),
                       FactoryBot.create(:aspect, category: device_type, name: "Computer"),
                       FactoryBot.create(:aspect, category: device_type, name: "Accessory"),
                       FactoryBot.create(:aspect, category: device_type, name: "Router"),
                     ]

game_mechanic      = FactoryBot.create(:category, name: "Game Mechanic")
game_mechanics     = [
                       FactoryBot.create(:aspect, category: game_mechanic, name: "First-Person Shooter"),
                       FactoryBot.create(:aspect, category: game_mechanic, name: "Couch Co-Op"),
                       FactoryBot.create(:aspect, category: game_mechanic, name: "MMORPG"),
                     ]

game_studio        = FactoryBot.create(:category, name: "Game Studio")
game_studios       = [
                       FactoryBot.create(:aspect, category: game_studio, name: "Capcom"),
                       FactoryBot.create(:aspect, category: game_studio, name: "Blizzard"),
                     ]

hollywood_studio   = FactoryBot.create(:category, name: "Hollywood Studio")
hollywood_studios  = [
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Netflix"),
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Amazon"),
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Hulu"),
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Disney"),
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Fox"),
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Sony"),
                       FactoryBot.create(:aspect, category: hollywood_studio, name: "Universal"),
                     ]

manufacturer       = FactoryBot.create(:category, name: "Manufacturer")
manufacturers      = [
                       FactoryBot.create(:aspect, category: manufacturer, name: "Unilever"),
                       FactoryBot.create(:aspect, category: manufacturer, name: "Proctor & Gamble"),
                       FactoryBot.create(:aspect, category: manufacturer, name: "Amazon Basics"),
                       FactoryBot.create(:aspect, category: manufacturer, name: "Tom Bihn"),
                       FactoryBot.create(:aspect, category: manufacturer, name: "The North Face"),
                     ]

music_label        = FactoryBot.create(:category, name: "Music Label")
music_labels       = [
                       FactoryBot.create(:aspect, category: music_label, name: "Warp"),
                       FactoryBot.create(:aspect, category: music_label, name: "Soul Jazz"),
                       FactoryBot.create(:aspect, category: music_label, name: "Plus 8"),
                       FactoryBot.create(:aspect, category: music_label, name: "Planet E"),
                       FactoryBot.create(:aspect, category: music_label, name: "Hyperdub"),
                       FactoryBot.create(:aspect, category: music_label, name: "Island"),
                     ]

musical_genre      = FactoryBot.create(:category, name: "Musical Genre")
musical_genres     = [
                       FactoryBot.create(:aspect, category: musical_genre, name: "AOR"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Ambient"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Chamber Pop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Classic Rock"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Classical"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Dance-Pop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Disco"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Doom Metal"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Dream Pop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Drum-n-Bass"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Dub"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Easy Listening"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Electro"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Film & TV"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Hardcore"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Hip-Hop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "House"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "IDM"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Indie-Pop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Jazz"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Jungle"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Krautrock"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "MOR"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Musical"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Original Score"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Original Soundtrack"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Pop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "R&B"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Rap"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Reggae"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Rock"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Rock-'n'-Roll"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Soul"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Spoken Word"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Synth-Pop"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Synthwave"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Techno"),
                       FactoryBot.create(:aspect, category: musical_genre, name: "Vocals"),
                     ]

narrative_genre    = FactoryBot.create(:category, name: "Narrative Genre")
narrative_genres   = [
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Action"),
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Adventure"),
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Horror"),
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Sci-Fi"),
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Fantasy"),
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Comedy"),
                       FactoryBot.create(:aspect, category: narrative_genre, name: "Drama"),
                     ]

podcast_network    = FactoryBot.create(:category, name: "Podcast Network")
podcast_networks   = [
                       FactoryBot.create(:aspect, category: podcast_network, name: "Maximum Fun"),
                       FactoryBot.create(:aspect, category: podcast_network, name: "Planet Broadcasting"),
                       FactoryBot.create(:aspect, category: podcast_network, name: "Relay.fm"),
                       FactoryBot.create(:aspect, category: podcast_network, name: "5by5"),
                     ]

product_type       = FactoryBot.create(:category, name: "Product Type")
product_types      = [
                       FactoryBot.create(:aspect, category: product_type, name: "Clothing"),
                       FactoryBot.create(:aspect, category: product_type, name: "Moisturizer"),
                       FactoryBot.create(:aspect, category: product_type, name: "Body Wash"),
                     ]

publication_type   = FactoryBot.create(:category, name: "Publication Type")
publication_types  = [
                       FactoryBot.create(:aspect, category: publication_type, name: "Magazine"),
                       FactoryBot.create(:aspect, category: publication_type, name: "Newspaper"),
                       FactoryBot.create(:aspect, category: publication_type, name: "Website"),
                     ]

publisher          = FactoryBot.create(:category, name: "Publisher")
publishers         = [
                       FactoryBot.create(:aspect, category: publisher, name: "Conde Nast"),
                       FactoryBot.create(:aspect, category: publisher, name: "Vox Media"),
                       FactoryBot.create(:aspect, category: publisher, name: "Marvel Comics"),
                       FactoryBot.create(:aspect, category: publisher, name: "DC Comics"),
                       FactoryBot.create(:aspect, category: publisher, name: "Vertigo"),
                     ]

radio_network      = FactoryBot.create(:category, name: "TV Network")
radio_networks     = [
                       FactoryBot.create(:aspect, category: radio_network, name: "NPR"),
                       FactoryBot.create(:aspect, category: radio_network, name: "PRI"),
                       FactoryBot.create(:aspect, category: radio_network, name: "Sirius XM"),
                     ]

song_type          = FactoryBot.create(:category, name: "Song Type")
song_types         = [
                       FactoryBot.create(:aspect, category: song_type, name: "Studio"),
                       FactoryBot.create(:aspect, category: song_type, name: "Remix"),
                       FactoryBot.create(:aspect, category: song_type, name: "Live"),
                     ]

tech_platform       = FactoryBot.create(:category, name: "Technology Platform")
tech_platforms      = [
                        FactoryBot.create(:aspect, category: tech_platform, name: "iOS"),
                        FactoryBot.create(:aspect, category: tech_platform, name: "macOS"),
                        FactoryBot.create(:aspect, category: tech_platform, name: "PS4"),
                        FactoryBot.create(:aspect, category: tech_platform, name: "Web"),
                      ]

tv_network         = FactoryBot.create(:category, name: "TV Network")
tv_networks        = [
                       FactoryBot.create(:aspect, category: tv_network, name: "Fox"),
                       FactoryBot.create(:aspect, category: tv_network, name: "ABC"),
                       FactoryBot.create(:aspect, category: tv_network, name: "NBC"),
                       FactoryBot.create(:aspect, category: tv_network, name: "CBS"),
                       FactoryBot.create(:aspect, category: tv_network, name: "AMC"),
                       FactoryBot.create(:aspect, category: tv_network, name: "Netflix"),
                       FactoryBot.create(:aspect, category: tv_network, name: "Hulu"),
                       FactoryBot.create(:aspect, category: tv_network, name: "Amazon"),
                     ]

tech_company       = FactoryBot.create(:category, name: "Tech Company")
tech_companies     = [
                       FactoryBot.create(:aspect, category: tech_company, name: "Rogue Amoeba"),
                       FactoryBot.create(:aspect, category: tech_company, name: "Many Tricks"),
                       FactoryBot.create(:aspect, category: tech_company, name: "Apple"),
                       FactoryBot.create(:aspect, category: tech_company, name: "Google"),
                       FactoryBot.create(:aspect, category: tech_company, name: "Facebook"),
                       FactoryBot.create(:aspect, category: tech_company, name: "Amazon"),
                     ]

##### FACETS

##### ROLES

song_artist                = FactoryBot.create(:role, medium: song, name: "Artist")
song_featured_artist       = FactoryBot.create(:role, medium: song, name: "Featured Artist")
song_songwriter            = FactoryBot.create(:role, medium: song, name: "Songwriter")
song_lyricist              = FactoryBot.create(:role, medium: song, name: "Lyricist")
song_composer              = FactoryBot.create(:role, medium: song, name: "Composer")
song_producer              = FactoryBot.create(:role, medium: song, name: "Producer")
song_executive_producer    = FactoryBot.create(:role, medium: song, name: "Executive Producer")
song_co_producer           = FactoryBot.create(:role, medium: song, name: "Co-Producer")
song_engineer              = FactoryBot.create(:role, medium: song, name: "Engineer")
song_vocalist              = FactoryBot.create(:role, medium: song, name: "Vocalist")
song_backing_vocalist      = FactoryBot.create(:role, medium: song, name: "Backing Vocalist")
song_musician              = FactoryBot.create(:role, medium: song, name: "Musician")
song_remixer               = FactoryBot.create(:role, medium: song, name: "Remixer")

album_artist               = FactoryBot.create(:role, medium: album, name: "Artist")
album_featured_artist      = FactoryBot.create(:role, medium: album, name: "Featured Artist")
album_songwriter           = FactoryBot.create(:role, medium: album, name: "Songwriter")
album_lyricist             = FactoryBot.create(:role, medium: album, name: "Lyricist")
album_composer             = FactoryBot.create(:role, medium: album, name: "Composer")
album_producer             = FactoryBot.create(:role, medium: album, name: "Producer")
album_executive_producer   = FactoryBot.create(:role, medium: album, name: "Executive Producer")
album_co_producer          = FactoryBot.create(:role, medium: album, name: "Co-Producer")
album_engineer             = FactoryBot.create(:role, medium: album, name: "Engineer")
album_vocalist             = FactoryBot.create(:role, medium: album, name: "Vocalist")
album_backing_vocalist     = FactoryBot.create(:role, medium: album, name: "Backing Vocalist")
album_musician             = FactoryBot.create(:role, medium: album, name: "Musician")

movie_director             = FactoryBot.create(:role, medium: movie, name: "Director")
movie_producer             = FactoryBot.create(:role, medium: movie, name: "Producer")
movie_executive_producer   = FactoryBot.create(:role, medium: movie, name: "Executive Producer")
movie_co_producer          = FactoryBot.create(:role, medium: movie, name: "Co-Producer")
movie_cinematographer      = FactoryBot.create(:role, medium: movie, name: "Cinematographer")
movie_screenwriter         = FactoryBot.create(:role, medium: movie, name: "Screenwriter")
movie_film_editor          = FactoryBot.create(:role, medium: movie, name: "Film Editor")
movie_music_supervisor     = FactoryBot.create(:role, medium: movie, name: "Music Supervisor")
movie_composer             = FactoryBot.create(:role, medium: movie, name: "Composer")
movie_sound_editor         = FactoryBot.create(:role, medium: movie, name: "Sound Editor")
movie_sound_effects        = FactoryBot.create(:role, medium: movie, name: "Sound Effects")

tv_show_creator            = FactoryBot.create(:role, medium: tv_show, name: "Creator")
tv_show_producer           = FactoryBot.create(:role, medium: tv_show, name: "Producer")
tv_show_executive_producer = FactoryBot.create(:role, medium: tv_show, name: "Executive Producer")
tv_show_co_producer        = FactoryBot.create(:role, medium: tv_show, name: "Co-Producer")
tv_show_showrunner         = FactoryBot.create(:role, medium: tv_show, name: "Showrunner")

tv_season_showrunner       = FactoryBot.create(:role, medium: tv_season, name: "Showrunner")

tv_episode_writer          = FactoryBot.create(:role, medium: tv_episode, name: "Writer")
tv_episode_director        = FactoryBot.create(:role, medium: tv_episode, name: "Director")
tv_episode_editor          = FactoryBot.create(:role, medium: tv_episode, name: "Film Editor")
tv_episode_composer        = FactoryBot.create(:role, medium: tv_episode, name: "Composer")

book_author                = FactoryBot.create(:role, medium: book, name: "Author")
book_editor                = FactoryBot.create(:role, medium: book, name: "Editor")
book_illustrator           = FactoryBot.create(:role, medium: book, name: "Illustrator")

comic_book_cartoonist      = FactoryBot.create(:role, medium: comic_book, name: "Cartoonist")
comic_book_writer          = FactoryBot.create(:role, medium: comic_book, name: "Writer")
comic_book_penciller       = FactoryBot.create(:role, medium: comic_book, name: "Penciller")
comic_book_inker           = FactoryBot.create(:role, medium: comic_book, name: "Inker")
comic_book_colorist        = FactoryBot.create(:role, medium: comic_book, name: "Colorist")
comic_book_letterer        = FactoryBot.create(:role, medium: comic_book, name: "Letterer")
comic_book_cover_artist    = FactoryBot.create(:role, medium: comic_book, name: "Cover Artist")

graphic_novel_cartoonist   = FactoryBot.create(:role, medium: graphic_novel, name: "Cartoonist")
graphic_novel_writer       = FactoryBot.create(:role, medium: graphic_novel, name: "Writer")
graphic_novel_penciller    = FactoryBot.create(:role, medium: graphic_novel, name: "Penciller")
graphic_novel_inker        = FactoryBot.create(:role, medium: graphic_novel, name: "Inker")
graphic_novel_colorist     = FactoryBot.create(:role, medium: graphic_novel, name: "Colorist")
graphic_novel_letterer     = FactoryBot.create(:role, medium: graphic_novel, name: "Letterer")
graphic_novel_cover_artist = FactoryBot.create(:role, medium: graphic_novel, name: "Cover Artist")

video_game_designer        = FactoryBot.create(:role, medium: video_game, name: "Designer")
video_game_developer       = FactoryBot.create(:role, medium: video_game, name: "Developer")

publication_writer         = FactoryBot.create(:role, medium: publication, name: "Writer")
publication_editor         = FactoryBot.create(:role, medium: publication, name: "Editor")
publication_publisher      = FactoryBot.create(:role, medium: publication, name: "Publisher")

artwork_artist             = FactoryBot.create(:role, medium: artwork, name: "Artist")

software_programmer        = FactoryBot.create(:role, medium: software, name: "Programmer")
software_designer          = FactoryBot.create(:role, medium: software, name: "Designer")

hardware_designer          = FactoryBot.create(:role, medium: hardware, name: "Designer")

product_designer           = FactoryBot.create(:role, medium: product, name: "Designer")

radio_show_host            = FactoryBot.create(:role, medium: radio_show, name: "Host")
radio_show_producer        = FactoryBot.create(:role, medium: radio_show, name: "Producer")

podcast_host               = FactoryBot.create(:role, medium: podcast, name: "Host")
podcast_producer           = FactoryBot.create(:role, medium: podcast, name: "Producer")

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

kate_bush_album_tki                    = FactoryBot.create(:work, medium: album, title: "The Kick Inside",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_lh                     = FactoryBot.create(:work, medium: album, title: "Lionheart",         "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_nfe                    = FactoryBot.create(:work, medium: album, title: "Never for Ever",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_td                     = FactoryBot.create(:work, medium: album, title: "The Dreaming",      "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_hol                    = FactoryBot.create(:work, medium: album, title: "Hounds of Love",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_tsw                    = FactoryBot.create(:work, medium: album, title: "The Sensual world", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_trs                    = FactoryBot.create(:work, medium: album, title: "The Red Shoes",     "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_aasoh                  = FactoryBot.create(:work, medium: album, title: "Aerial",            "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_dc                     = FactoryBot.create(:work, medium: album, title: "Director's Cut",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_fwfs                   = FactoryBot.create(:work, medium: album, title: "50 Words for Snow", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_btdl                   = FactoryBot.create(:work, medium: album, title: "Before the Dawn",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })

plastikman_album_sheet_one             = FactoryBot.create(:work, medium: album, title: "Sheet One",        "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_musik                 = FactoryBot.create(:work, medium: album, title: "Musik",            "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_recycled_plastik      = FactoryBot.create(:work, medium: album, title: "Recycled Plastik", "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_consumed              = FactoryBot.create(:work, medium: album, title: "Consumed",         "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_artifakts             = FactoryBot.create(:work, medium: album, title: "Artifakts (BC)",   "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_closer                = FactoryBot.create(:work, medium: album, title: "Closer",           "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_ex                    = FactoryBot.create(:work, medium: album, title: "EX",               "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

plastikman_song_hump                   = FactoryBot.create(:work, medium: song, title: "Hump",             "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_song_plastique              = FactoryBot.create(:work, medium: song, title: "Plastique",        "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

fleetwood_mac_album_fleetwood_mac      = FactoryBot.create(:work, medium: album, title: "Fleetwood Mac",      "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_rumors             = FactoryBot.create(:work, medium: album, title: "Rumors",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tusk               = FactoryBot.create(:work, medium: album, title: "Tusk",               "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_mirage             = FactoryBot.create(:work, medium: album, title: "Mirage",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tango_in_the_night = FactoryBot.create(:work, medium: album, title: "Tango in the Night", "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

fleetwood_mac_song_little_lies         = FactoryBot.create(:work, medium: song, title: "Little Lies",         "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dreams              = FactoryBot.create(:work, medium: song, title: "Dreams",              "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dont_stop           = FactoryBot.create(:work, medium: song, title: "Don't Stop",          "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_gold_dust_woman     = FactoryBot.create(:work, medium: song, title: "Gold Dust Woman",     "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

spawn_song_hammerknock                 = FactoryBot.create(:work, medium: song, title: "Hammerknock",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_tension                     = FactoryBot.create(:work, medium: song, title: "Tension",          "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltrator                 = FactoryBot.create(:work, medium: song, title: "Infiltrator",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltration                = FactoryBot.create(:work, medium: song, title: "Infiltration",     "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_the_thinking_man            = FactoryBot.create(:work, medium: song, title: "The Thinking Man", "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })

the_kooky_scientist_album_unpopular_science = FactoryBot.create(:work, medium: album, title: "Unpopular Science", "credits_attributes" => { "0" => { "creator_id" => the_kooky_scientist.id } })

##### POSTS: REVIEWS & STANDALONE

# 10.times { FactoryBot.create(:minimal_article, random_status, author: brian, body: random_paragraphs, title: random_title) }
#
# 5.times { FactoryBot.create(:complete_mixtape, :published) }
#
# Work.all.each do |work|
#   FactoryBot.create(:minimal_review, random_status, author: brian, body: random_paragraphs, work: work)
# end
