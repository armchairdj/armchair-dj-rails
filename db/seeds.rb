require "ffaker"

brian = User.create_with(role: :admin, username: "armchairdj", first_name: "Brian", middle_name: "J.", last_name: "Dillard", password: "password1234").find_or_create_by(email: "armchairdj@gmail.com")

1.times do
  FactoryBot.create(                     :song_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))
  FactoryBot.create(       :collaborative_book_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 6).join("\n\n"))
  FactoryBot.create(       :collaborative_song_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(                    :movie_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs(17).join("\n\n"))
  FactoryBot.create(                    :remix_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(      :collaborative_album_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 7).join("\n\n"))
  FactoryBot.create(    :special_edition_album_review, :draft,     user: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))

  FactoryBot.create(                 :standalone_post, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                  :podcast_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs(12).join("\n\n"))
  FactoryBot.create(      :directors_cut_movie_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                :newspaper_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 5).join("\n\n"))
  FactoryBot.create(                 :magazine_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                   :memoir_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(  :collaborative_newspaper_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                  :product_review, :scheduled, user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))

  FactoryBot.create(                    :remix_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(11).join("\n\n"))
  FactoryBot.create(                    :album_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(                  :tv_show_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                 :hardware_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(45).join("\n\n"))
  FactoryBot.create(                     :game_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(    :collaborative_artwork_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(      :collaborative_movie_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                     :book_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(                    :remix_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                    :album_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(15).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(      :collaborative_comic_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 8).join("\n\n"))
  FactoryBot.create(                    :remix_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(11).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(       :collaborative_game_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(11).join("\n\n"))
  FactoryBot.create(                 :software_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(                     :game_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(    :collaborative_tv_show_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                 :hardware_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                    :comic_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(                     :song_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
  FactoryBot.create(                  :artwork_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(10).join("\n\n"))
  FactoryBot.create(                     :game_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(22).join("\n\n"))
  FactoryBot.create(   :collaborative_magazine_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 1).join("\n\n"))
  FactoryBot.create(                 :standalone_post, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(12).join("\n\n"))
  FactoryBot.create(                 :software_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(20).join("\n\n"))
  FactoryBot.create(               :radio_show_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(10).join("\n\n"))
  FactoryBot.create(                  :podcast_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs(15).join("\n\n"))
  FactoryBot.create(   :collaborative_software_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 9).join("\n\n"))
  FactoryBot.create(    :collaborative_product_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))

  FactoryBot.create(     :hounds_of_love_album_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 4).join("\n\n"))
  FactoryBot.create(              :unity_album_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 3).join("\n\n"))
  FactoryBot.create(        :junior_boys_remix_review, :published, user: brian, body: FFaker::HipsterIpsum.paragraphs( 2).join("\n\n"))
end
