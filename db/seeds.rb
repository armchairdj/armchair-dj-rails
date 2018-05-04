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

song       = FactoryBot.create(:medium, name: "Song"      )
album      = FactoryBot.create(:medium, name: "Album"     )
movie      = FactoryBot.create(:medium, name: "Movie"     )
tv_show    = FactoryBot.create(:medium, name: "TV Show"   )
book       = FactoryBot.create(:medium, name: "Book"      )
comic      = FactoryBot.create(:medium, name: "Comic Book")
game       = FactoryBot.create(:medium, name: "Game"      )
newspaper  = FactoryBot.create(:medium, name: "Newspaper" )
magazine   = FactoryBot.create(:medium, name: "Magazine"  )
artwork    = FactoryBot.create(:medium, name: "Artwork"   )
software   = FactoryBot.create(:medium, name: "Software"  )
hardware   = FactoryBot.create(:medium, name: "Hardware"  )
product    = FactoryBot.create(:medium, name: "Product"   )
radio_show = FactoryBot.create(:medium, name: "Radio Show")
podcast    = FactoryBot.create(:medium, name: "Podcast"   )

##### GENRES

# song_trip_hop   = FactoryBot.create(:genre, medium: song,     name: "Trip-Hop" )
# song_techno     = FactoryBot.create(:genre, medium: song,     name: "Techno"   )
# song_jungle     = FactoryBot.create(:genre, medium: song,     name: "Jungle"   )
# song_dream_pop  = FactoryBot.create(:genre, medium: song,     name: "Dream Pop")
# song_heavy      = FactoryBot.create(:genre, medium: song,     name: "Heavy"    )
#
# album_trip_hop  = FactoryBot.create(:genre, medium: album,   name: "Trip-Hop" )
# album_techno    = FactoryBot.create(:genre, medium: album,   name: "Techno"   )
# album_jungle    = FactoryBot.create(:genre, medium: album,   name: "Jungle"   )
# album_dream_pop = FactoryBot.create(:genre, medium: album,   name: "Dream Pop")
# album_heavy     = FactoryBot.create(:genre, medium: album,   name: "Heavy"    )
#
# movie_comedy    = FactoryBot.create(:genre, medium: movie,   name: "Comedy"   )
# movie_drama     = FactoryBot.create(:genre, medium: movie,   name: "Drama"    )
# movie_horror    = FactoryBot.create(:genre, medium: movie,   name: "Horror"   )
# movie_action    = FactoryBot.create(:genre, medium: movie,   name: "Action"   )
# movie_sci_fi    = FactoryBot.create(:genre, medium: movie,   name: "Sci-Fi"   )
#
# tv_show_comedy  = FactoryBot.create(:genre, medium: tv_show, name: "Comedy"   )
# tv_show_drama   = FactoryBot.create(:genre, medium: tv_show, name: "Drama"    )
# tv_show_horror  = FactoryBot.create(:genre, medium: tv_show, name: "Horror"   )
# tv_show_action  = FactoryBot.create(:genre, medium: tv_show, name: "Action"   )
# tv_show_sci_fi  = FactoryBot.create(:genre, medium: tv_show, name: "Sci-Fi"   )
#
# book_sci_fi     = FactoryBot.create(:genre, medium: book,    name: "Sci-Fi"   )
# book_fantasy    = FactoryBot.create(:genre, medium: book,    name: "Fantasy"  )
# book_memoir     = FactoryBot.create(:genre, medium: book,    name: "Memoir"   )
#
# comic_indie     = FactoryBot.create(:genre, medium: comic,   name: "Indie"    )
# comic_horror    = FactoryBot.create(:genre, medium: comic,   name: "Horror"   )
# comic_superhero = FactoryBot.create(:genre, medium: comic,   name: "Superhero")
#
# game_horror     = FactoryBot.create(:genre, medium: game,    name: "Horror"   )
# game_adventure  = FactoryBot.create(:genre, medium: game,    name: "Adventure")
# game_sports     = FactoryBot.create(:genre, medium: game,    name: "Sports"   )

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
tv_show_showrunner         = FactoryBot.create(:role, medium: tv_show, name: "xxx")

book_author                = FactoryBot.create(:role, medium: book, name: "Author")
book_illustrator           = FactoryBot.create(:role, medium: book, name: "Illustrator")
book_editor                = FactoryBot.create(:role, medium: book, name: "Editor")

comic_cartoonist           = FactoryBot.create(:role, medium: comic, name: "Cartoonist")
comic_penciller            = FactoryBot.create(:role, medium: comic, name: "Penciller")
comic_inker                = FactoryBot.create(:role, medium: comic, name: "Inker")
comic_colorist             = FactoryBot.create(:role, medium: comic, name: "Colorist")
comic_letterer             = FactoryBot.create(:role, medium: comic, name: "Letterer")

game_platform              = FactoryBot.create(:role, medium: game, name: "Game Platform")
game_studio                = FactoryBot.create(:role, medium: game, name: "Game Studio")

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
