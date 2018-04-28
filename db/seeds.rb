require "ffaker"

brian = User.create_with(role: :super_admin, username: "armchairdj", first_name: "Brian", middle_name: "J.", last_name: "Dillard", password: "password1234").find_or_create_by(email: "armchairdj@gmail.com")

1.times do
  FactoryBot.create(                     :song_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))
  FactoryBot.create(       :collaborative_book_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 6).join("\n\n"))
  FactoryBot.create(       :collaborative_song_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(                    :movie_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs(17).join("\n\n"))
  FactoryBot.create(                    :remix_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(      :collaborative_album_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 7).join("\n\n"))
  FactoryBot.create(    :special_edition_album_review, :draft,     author: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))

  FactoryBot.create(                 :standalone_post, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                  :podcast_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs(12).join("\n\n"))
  FactoryBot.create(      :directors_cut_movie_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                :newspaper_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))
  FactoryBot.create(                 :magazine_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                   :memoir_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(  :collaborative_newspaper_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                  :product_review, :scheduled, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))

  FactoryBot.create(                    :remix_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(11).join("\n\n"))
  FactoryBot.create(                    :album_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(                  :tv_show_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                 :hardware_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(45).join("\n\n"))
  FactoryBot.create(                     :game_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(    :collaborative_artwork_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(      :collaborative_movie_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                     :book_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                    :remix_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                    :album_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(15).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(      :collaborative_comic_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 8).join("\n\n"))
  FactoryBot.create(                    :remix_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(11).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(       :collaborative_game_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(11).join("\n\n"))
  FactoryBot.create(                 :software_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(                     :game_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(    :collaborative_tv_show_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                 :hardware_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                    :comic_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                     :song_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                  :artwork_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(10).join("\n\n"))
  FactoryBot.create(                     :game_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(22).join("\n\n"))
  FactoryBot.create(   :collaborative_magazine_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(12).join("\n\n"))
  FactoryBot.create(                 :software_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(20).join("\n\n"))
  FactoryBot.create(               :radio_show_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(10).join("\n\n"))
  FactoryBot.create(                  :podcast_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(15).join("\n\n"))
  FactoryBot.create(   :collaborative_software_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(    :collaborative_product_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
end

FactoryBot.create(     :hounds_of_love_album_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
FactoryBot.create(              :unity_album_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
FactoryBot.create(        :junior_boys_remix_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))

FactoryBot.create(:fleetwood_mac_with_members)
FactoryBot.create(:richie_hawtin_with_pseudonyms)

bjork = FactoryBot.create(:musician, name: "Bjork")
plaid = FactoryBot.create(:musician, name: "Plaid")
lars  = FactoryBot.create(:director, name: "Lars von Trier")

FactoryBot.create(:post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(1).first, work_attributes: {
  "title"                    => "Not for Threes",
  "medium"                   => "album",
  "credits_attributes" => {
    "0" => FactoryBot.attributes_for(:credit, creator_id: plaid.id)
  },
  "contributions_attributes" => {
    "0" => FactoryBot.attributes_for(:contribution, role: :musical_featured_artist, creator_id: bjork.id),
    "1" => FactoryBot.attributes_for(:contribution, role: :singer                 , creator_id: bjork.id)
  }
})

FactoryBot.create(:post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(1).first, work_attributes: {
  "title"                    => "Lilith",
  "medium"                   => "song",
  "credits_attributes" => {
    "0" => FactoryBot.attributes_for(:credit, creator_id: plaid.id)
  },
  "contributions_attributes" => {
    "0" => FactoryBot.attributes_for(:contribution, role: :musical_featured_artist, creator_id: bjork.id),
    "1" => FactoryBot.attributes_for(:contribution, role: :singer                 , creator_id: bjork.id)
  }
})

FactoryBot.create(:post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(1).first, work_attributes: {
  "title"                    => "Post",
  "medium"                   => "album",
  "credits_attributes" => {
    "0" => FactoryBot.attributes_for(:credit, creator_id: bjork.id)
  },
  "contributions_attributes" => {
    "0" => FactoryBot.attributes_for(:contribution, role: :music_producer, creator_id: plaid.id)
  }
})

FactoryBot.create(:post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(1).first, work_attributes: {
  "title"                    => "Dancer in the Dark",
  "medium"                   => "movie",
  "credits_attributes" => {
    "0" => FactoryBot.attributes_for(:credit,  creator_id: lars.id)
  },
  "contributions_attributes" => {
    "0" => FactoryBot.attributes_for(:contribution, role: :producer, creator_id: bjork.id)
  }
})

FactoryBot.create(:post, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs(1).first, work_attributes: {
  "title"                    => "Bjork",
  "medium"                   => "book",
  "credits_attributes" => {
    "0" => FactoryBot.attributes_for(:credit,  creator_id: bjork.id)
  },
  "contributions_attributes" => {
    "0" => FactoryBot.attributes_for(:contribution, role: :author,   creator_id: bjork.id)
  }
})
