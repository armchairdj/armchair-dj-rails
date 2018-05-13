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

brian = User.create_with(role: :super_admin, username: "armchairdj", first_name: "Brian", middle_name: "J.", last_name: "Dillard", password: "password1234").find_or_create_by(email: "armchairdj@gmail.com")

##### MEDIA

song        = FactoryBot.create(:medium, name: "Song"      )
album       = FactoryBot.create(:medium, name: "Album"     )
movie       = FactoryBot.create(:medium, name: "Movie"     )
tv_show     = FactoryBot.create(:medium, name: "TV Show"   )
book        = FactoryBot.create(:medium, name: "Book"      )
comic       = FactoryBot.create(:medium, name: "Comic Book")
game        = FactoryBot.create(:medium, name: "Game"      )
publication = FactoryBot.create(:medium, name: "Publication" )
artwork     = FactoryBot.create(:medium, name: "Artwork"   )
software    = FactoryBot.create(:medium, name: "Software"  )
hardware    = FactoryBot.create(:medium, name: "Hardware"  )
product     = FactoryBot.create(:medium, name: "Product"   )
radio_show  = FactoryBot.create(:medium, name: "Radio Show")
podcast     = FactoryBot.create(:medium, name: "Podcast"   )

##### CATEGORIES & TAGS

album_type         = FactoryBot.create(:category, name: "Album Type")
album_types        = [
                       FactoryBot.create(:tag, category: album_type, name: "LP"),
                       FactoryBot.create(:tag, category: album_type, name: "EP"),
                       FactoryBot.create(:tag, category: album_type, name: "Single"),
                       FactoryBot.create(:tag, category: album_type, name: "Boxed Set"),
                       FactoryBot.create(:tag, category: album_type, name: "Download"),
                     ]

art_medium         = FactoryBot.create(:category, name: "Artistic Medium")
art_media          = [
                       FactoryBot.create(:tag, category: art_medium, name: "Painting"),
                       FactoryBot.create(:tag, category: art_medium, name: "Sculpture"),
                       FactoryBot.create(:tag, category: art_medium, name: "Photography"),
                       FactoryBot.create(:tag, category: art_medium, name: "Mixed Media"),
                     ]

art_movement       = FactoryBot.create(:category, name: "Artistic Movement")
art_movements      = [
                       FactoryBot.create(:tag, category: art_movement, name: "Pop Art"),
                       FactoryBot.create(:tag, category: art_movement, name: "Postmodernism"),
                       FactoryBot.create(:tag, category: art_movement, name: "Modernism"),
                     ]

audio_show_format  = FactoryBot.create(:category, name: "Audio Show Format")
audio_show_formats = [
                       FactoryBot.create(:tag, category: audio_show_format, name: "Interview"),
                       FactoryBot.create(:tag, category: audio_show_format, name: "Discussion"),
                       FactoryBot.create(:tag, category: audio_show_format, name: "Narrative"),
                       FactoryBot.create(:tag, category: audio_show_format, name: "Documentary"),
                     ]

device_type        = FactoryBot.create(:category, name: "Device Type")
device_types       = [
                       FactoryBot.create(:tag, category: device_type, name: "Phone"),
                       FactoryBot.create(:tag, category: device_type, name: "Computer"),
                       FactoryBot.create(:tag, category: device_type, name: "Accessory"),
                       FactoryBot.create(:tag, category: device_type, name: "Router"),
                     ]

game_mechanic      = FactoryBot.create(:category, name: "Game Mechanic")
game_mechanics     = [
                       FactoryBot.create(:tag, category: game_mechanic, name: "First-Person Shooter"),
                       FactoryBot.create(:tag, category: game_mechanic, name: "Couch Co-Op"),
                       FactoryBot.create(:tag, category: game_mechanic, name: "MMORPG"),
                     ]

game_studio        = FactoryBot.create(:category, name: "Game Studio")
game_studios       = [
                       FactoryBot.create(:tag, category: game_studio, name: "Capcom"),
                       FactoryBot.create(:tag, category: game_studio, name: "Blizzard"),
                     ]

hollywood_studio   = FactoryBot.create(:category, name: "Hollywood Studio")
hollywood_studios  = [
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Netflix"),
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Amazon"),
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Hulu"),
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Disney"),
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Fox"),
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Sony"),
                       FactoryBot.create(:tag, category: hollywood_studio, name: "Universal"),
                     ]

manufacturer       = FactoryBot.create(:category, name: "Manufacturer")
manufacturers      = [
                       FactoryBot.create(:tag, category: manufacturer, name: "Unilever"),
                       FactoryBot.create(:tag, category: manufacturer, name: "Proctor & Gamble"),
                       FactoryBot.create(:tag, category: manufacturer, name: "Amazon Basics"),
                       FactoryBot.create(:tag, category: manufacturer, name: "Tom Bihn"),
                       FactoryBot.create(:tag, category: manufacturer, name: "The North Face"),
                     ]

music_label        = FactoryBot.create(:category, name: "Music Label")
music_labels       = [
                       FactoryBot.create(:tag, category: music_label, name: "Warp"),
                       FactoryBot.create(:tag, category: music_label, name: "Soul Jazz"),
                       FactoryBot.create(:tag, category: music_label, name: "Plus 8"),
                       FactoryBot.create(:tag, category: music_label, name: "Planet E"),
                       FactoryBot.create(:tag, category: music_label, name: "Hyperdub"),
                       FactoryBot.create(:tag, category: music_label, name: "Island"),
                     ]

musical_genre      = FactoryBot.create(:category, name: "Musical Genre")
musical_genres     = [
                       FactoryBot.create(:tag, category: musical_genre, name: "AOR"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Ambient"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Chamber Pop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Classic Rock"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Classical"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Dance-Pop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Disco"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Doom Metal"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Dream Pop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Drum-n-Bass"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Dub"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Easy Listening"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Electro"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Film & TV"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Hardcore"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Hip-Hop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "House"),
                       FactoryBot.create(:tag, category: musical_genre, name: "IDM"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Indie-Pop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Jazz"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Jungle"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Krautrock"),
                       FactoryBot.create(:tag, category: musical_genre, name: "MOR"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Musical"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Original Score"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Original Soundtrack"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Pop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "R&B"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Rap"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Reggae"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Rock"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Rock-'n'-Roll"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Soul"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Spoken Word"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Synth-Pop"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Synthwave"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Techno"),
                       FactoryBot.create(:tag, category: musical_genre, name: "Vocals"),
                     ]

narrative_genre    = FactoryBot.create(:category, name: "Narrative Genre")
narrative_genres   = [
                       FactoryBot.create(:tag, category: narrative_genre, name: "Action"),
                       FactoryBot.create(:tag, category: narrative_genre, name: "Adventure"),
                       FactoryBot.create(:tag, category: narrative_genre, name: "Horror"),
                       FactoryBot.create(:tag, category: narrative_genre, name: "Sci-Fi"),
                       FactoryBot.create(:tag, category: narrative_genre, name: "Fantasy"),
                       FactoryBot.create(:tag, category: narrative_genre, name: "Comedy"),
                       FactoryBot.create(:tag, category: narrative_genre, name: "Drama"),
                     ]

podcast_network    = FactoryBot.create(:category, name: "Podcast Network")
podcast_networks   = [
                       FactoryBot.create(:tag, category: podcast_network, name: "Maximum Fun"),
                       FactoryBot.create(:tag, category: podcast_network, name: "Planet Broadcasting"),
                       FactoryBot.create(:tag, category: podcast_network, name: "Relay.fm"),
                       FactoryBot.create(:tag, category: podcast_network, name: "5by5"),
                     ]

product_type       = FactoryBot.create(:category, name: "Product Type")
product_types      = [
                       FactoryBot.create(:tag, category: product_type, name: "Clothing"),
                       FactoryBot.create(:tag, category: product_type, name: "Moisturizer"),
                       FactoryBot.create(:tag, category: product_type, name: "Body Wash"),
                     ]

publication_type   = FactoryBot.create(:category, name: "Publication Type")
publication_types  = [
                       FactoryBot.create(:tag, category: publication_type, name: "Magazine"),
                       FactoryBot.create(:tag, category: publication_type, name: "Newspaper"),
                       FactoryBot.create(:tag, category: publication_type, name: "Website"),
                     ]

publisher          = FactoryBot.create(:category, name: "Publisher")
publishers         = [
                       FactoryBot.create(:tag, category: publisher, name: "Conde Nast"),
                       FactoryBot.create(:tag, category: publisher, name: "Vox Media"),
                       FactoryBot.create(:tag, category: publisher, name: "Marvel Comics"),
                       FactoryBot.create(:tag, category: publisher, name: "DC Comics"),
                       FactoryBot.create(:tag, category: publisher, name: "Vertigo"),
                     ]

radio_network      = FactoryBot.create(:category, name: "TV Network")
radio_networks     = [
                       FactoryBot.create(:tag, category: radio_network, name: "NPR"),
                       FactoryBot.create(:tag, category: radio_network, name: "PRI"),
                       FactoryBot.create(:tag, category: radio_network, name: "Sirius XM"),
                     ]

song_type          = FactoryBot.create(:category, name: "Song Type")
song_types         = [
                       FactoryBot.create(:tag, category: song_type, name: "Studio"),
                       FactoryBot.create(:tag, category: song_type, name: "Remix"),
                       FactoryBot.create(:tag, category: song_type, name: "Live"),
                     ]

tech_platform       = FactoryBot.create(:category, name: "Technology Platform")
tech_platforms      = [
                        FactoryBot.create(:tag, category: tech_platform, name: "iOS"),
                        FactoryBot.create(:tag, category: tech_platform, name: "macOS"),
                        FactoryBot.create(:tag, category: tech_platform, name: "PS4"),
                        FactoryBot.create(:tag, category: tech_platform, name: "Web"),
                      ]

tv_network         = FactoryBot.create(:category, name: "TV Network")
tv_networks        = [
                       FactoryBot.create(:tag, category: tv_network, name: "Fox"),
                       FactoryBot.create(:tag, category: tv_network, name: "ABC"),
                       FactoryBot.create(:tag, category: tv_network, name: "NBC"),
                       FactoryBot.create(:tag, category: tv_network, name: "CBS"),
                       FactoryBot.create(:tag, category: tv_network, name: "AMC"),
                       FactoryBot.create(:tag, category: tv_network, name: "Netflix"),
                       FactoryBot.create(:tag, category: tv_network, name: "Hulu"),
                       FactoryBot.create(:tag, category: tv_network, name: "Amazon"),
                     ]

tech_company       = FactoryBot.create(:category, name: "Tech Company")
tech_companies     = [
                       FactoryBot.create(:tag, category: tech_company, name: "Rogue Amoeba"),
                       FactoryBot.create(:tag, category: tech_company, name: "Many Tricks"),
                       FactoryBot.create(:tag, category: tech_company, name: "Apple"),
                       FactoryBot.create(:tag, category: tech_company, name: "Google"),
                       FactoryBot.create(:tag, category: tech_company, name: "Facebook"),
                       FactoryBot.create(:tag, category: tech_company, name: "Amazon"),
                     ]

##### FACETS

song_facets = [
  FactoryBot.create(:facet, medium: song, category: musical_genre),
  FactoryBot.create(:facet, medium: song, category: music_label),
  FactoryBot.create(:facet, medium: song, category: song_type),
]

album_facets = [
  FactoryBot.create(:facet, medium: album, category: musical_genre),
  FactoryBot.create(:facet, medium: album, category: music_label),
  FactoryBot.create(:facet, medium: album, category: album_type),
]

movie_facets = [
  FactoryBot.create(:facet, medium: movie, category: narrative_genre),
  FactoryBot.create(:facet, medium: movie, category: hollywood_studio),
]

tv_show_facets = [
  FactoryBot.create(:facet, medium: tv_show, category: narrative_genre),
  FactoryBot.create(:facet, medium: tv_show, category: hollywood_studio),
  FactoryBot.create(:facet, medium: tv_show, category: tv_network),
]

radio_show_facets = [
  FactoryBot.create(:facet, medium: radio_show, category: narrative_genre),
  FactoryBot.create(:facet, medium: radio_show, category: audio_show_format),
  FactoryBot.create(:facet, medium: radio_show, category: radio_network),
]

podcast_facets = [
  FactoryBot.create(:facet, medium: podcast, category: narrative_genre),
  FactoryBot.create(:facet, medium: podcast, category: audio_show_format),
  FactoryBot.create(:facet, medium: podcast, category: podcast_network),
]

book_facets = [
  FactoryBot.create(:facet, medium: book, category: narrative_genre),
  FactoryBot.create(:facet, medium: book, category: publisher),
]

comic_facets = [
  FactoryBot.create(:facet, medium: comic, category: narrative_genre),
  FactoryBot.create(:facet, medium: comic, category: publisher),
]

game_facets = [
  FactoryBot.create(:facet, medium: game, category: game_studio),
  FactoryBot.create(:facet, medium: game, category: game_mechanic),
  FactoryBot.create(:facet, medium: game, category: tech_platform),
]

publication_facets = [
  FactoryBot.create(:facet, medium: publication, category: publisher),
  FactoryBot.create(:facet, medium: publication, category: publication_type),
]

artwork_facets = [
  FactoryBot.create(:facet, medium: artwork, category: art_medium),
  FactoryBot.create(:facet, medium: artwork, category: art_movement),
]

hardware_facets = [
  FactoryBot.create(:facet, medium: hardware, category: device_type),
  FactoryBot.create(:facet, medium: hardware, category: tech_platform),
  FactoryBot.create(:facet, medium: hardware, category: tech_company),
]

software_facets = [
  FactoryBot.create(:facet, medium: software, category: tech_platform),
  FactoryBot.create(:facet, medium: software, category: tech_company),
]

product_facets = [
  FactoryBot.create(:facet, medium: product, category: manufacturer),
  FactoryBot.create(:facet, medium: product, category: product_type),
]

##### ROLES

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

tv_show_director           = FactoryBot.create(:role, medium: tv_show, name: "Director")
tv_show_producer           = FactoryBot.create(:role, medium: tv_show, name: "Producer")
tv_show_executive_producer = FactoryBot.create(:role, medium: tv_show, name: "Executive Producer")
tv_show_co_producer        = FactoryBot.create(:role, medium: tv_show, name: "Co-Producer")
tv_show_cinematographer    = FactoryBot.create(:role, medium: tv_show, name: "Cinematographer")
tv_show_showrunner         = FactoryBot.create(:role, medium: tv_show, name: "Showrunner")

book_author                = FactoryBot.create(:role, medium: book, name: "Author")
book_illustrator           = FactoryBot.create(:role, medium: book, name: "Illustrator")
book_editor                = FactoryBot.create(:role, medium: book, name: "Editor")

comic_cartoonist           = FactoryBot.create(:role, medium: comic, name: "Cartoonist")
comic_penciller            = FactoryBot.create(:role, medium: comic, name: "Penciller")
comic_inker                = FactoryBot.create(:role, medium: comic, name: "Inker")
comic_colorist             = FactoryBot.create(:role, medium: comic, name: "Colorist")
comic_letterer             = FactoryBot.create(:role, medium: comic, name: "Letterer")

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

kate_bush_album_tki   = FactoryBot.create(:work, medium: album, title: "The Kick Inside",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_lh    = FactoryBot.create(:work, medium: album, title: "Lionheart",         "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_nfe   = FactoryBot.create(:work, medium: album, title: "Never for Ever",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_td    = FactoryBot.create(:work, medium: album, title: "The Dreaming",      "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_hol   = FactoryBot.create(:work, medium: album, title: "Hounds of Love",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_tsw   = FactoryBot.create(:work, medium: album, title: "The Sensual world", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_trs   = FactoryBot.create(:work, medium: album, title: "The Red Shoes",     "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_aasoh = FactoryBot.create(:work, medium: album, title: "Aerial",            "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_dc    = FactoryBot.create(:work, medium: album, title: "Director's Cut",    "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_fwfs  = FactoryBot.create(:work, medium: album, title: "50 Words for Snow", "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })
kate_bush_album_btdl  = FactoryBot.create(:work, medium: album, title: "Before the Dawn",   "credits_attributes" => { "0" => { "creator_id" => kate_bush.id } })

plastikman_album_sheet_one        = FactoryBot.create(:work, medium: album, title: "Sheet One",        "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_musik            = FactoryBot.create(:work, medium: album, title: "Musik",            "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_recycled_plastik = FactoryBot.create(:work, medium: album, title: "Recycled Plastik", "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_consumed         = FactoryBot.create(:work, medium: album, title: "Consumed",         "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_artifakts        = FactoryBot.create(:work, medium: album, title: "Artifakts (BC)",   "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_closer           = FactoryBot.create(:work, medium: album, title: "Closer",           "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_album_ex               = FactoryBot.create(:work, medium: album, title: "EX",               "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

plastikman_song_hump             = FactoryBot.create(:work, medium: song, title: "Hump",             "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })
plastikman_song_plastique        = FactoryBot.create(:work, medium: song, title: "Plastique",        "credits_attributes" => { "0" => { "creator_id" => plastikman.id } })

fleetwood_mac_album_fleetwood_mac      = FactoryBot.create(:work, medium: album, title: "Fleetwood Mac",      "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_rumors             = FactoryBot.create(:work, medium: album, title: "Rumors",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tusk               = FactoryBot.create(:work, medium: album, title: "Tusk",               "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_mirage             = FactoryBot.create(:work, medium: album, title: "Mirage",             "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_album_tango_in_the_night = FactoryBot.create(:work, medium: album, title: "Tango in the Night", "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

fleetwood_mac_song_little_lies        = FactoryBot.create(:work, medium: song, title: "Little Lies",         "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dreams             = FactoryBot.create(:work, medium: song, title: "Dreams",              "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_dont_stop          = FactoryBot.create(:work, medium: song, title: "Don't Stop",          "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })
fleetwood_mac_song_gold_dust_woman    = FactoryBot.create(:work, medium: song, title: "Gold Dust Woman",     "credits_attributes" => { "0" => { "creator_id" => fleetwood_mac.id } })

spawn_song_hammerknock      = FactoryBot.create(:work, medium: song, title: "Hammerknock",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_tension          = FactoryBot.create(:work, medium: song, title: "Tension",          "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltrator      = FactoryBot.create(:work, medium: song, title: "Infiltrator",      "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_infiltration     = FactoryBot.create(:work, medium: song, title: "Infiltration",     "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })
spawn_song_the_thinking_man = FactoryBot.create(:work, medium: song, title: "The Thinking Man", "credits_attributes" => { "0" => { "creator_id" => spawn_group.id } })

the_kooky_scientist_album_unpopular_science = FactoryBot.create(:work, medium: album, title: "Unpopular Science", "credits_attributes" => { "0" => { "creator_id" => the_kooky_scientist.id } })

##### POSTS: REVIEWS & STANDALONE

Work.all.each do |work|
  FactoryBot.create(:review,          random_status, author: brian, body: random_paragraphs, work: work)

  FactoryBot.create(:standalone_post, random_status, author: brian, body: random_paragraphs, title: random_title)
end
