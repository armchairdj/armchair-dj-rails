require "ffaker"

brian = User.create_with(role: :super_admin, username: "armchairdj", first_name: "Brian", middle_name: "J.", last_name: "Dillard", password: "password1234").find_or_create_by(email: "armchairdj@gmail.com")

1.times do

end

FactoryBot.create(     :hounds_of_love_album_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
FactoryBot.create(              :unity_album_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
FactoryBot.create(        :junior_boys_remix_review, :published, author: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))

FactoryBot.create(:fleetwood_mac_with_members)
FactoryBot.create(:richie_hawtin_with_pseudonyms)

bjork = FactoryBot.create(:minimal_creator, name: "Bjork")
plaid = FactoryBot.create(:minimal_creator, name: "Plaid")
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
