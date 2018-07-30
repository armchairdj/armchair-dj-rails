# == Schema Information
#
# Table name: playlistings
#
#  id          :bigint(8)        not null, primary key
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :bigint(8)
#  work_id     :bigint(8)
#
# Indexes
#
#  index_playlistings_on_playlist_id  (playlist_id)
#  index_playlistings_on_work_id      (work_id)
#

FactoryBot.define do
  factory :playlisting do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_existing_playlist do
      playlist_id { create(:minimal_playlist).id }
    end

    trait :with_draft_post do
      after(:create) do |playlisting|
        create(:review, :draft, author_id: playlisting.playlist.author.id, work_id: playlisting.work.id)
      end
    end

    trait :with_scheduled_post do
      after(:create) do |playlisting|
        create(:review, :scheduled, author_id: playlisting.playlist.author.id, work_id: playlisting.work.id)
      end
    end

    trait :with_published_post do
      after(:create) do |playlisting|
        create(:minimal_review, :published, author_id: playlisting.playlist.author.id, work_id: playlisting.work.id)
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_playlisting do
      with_existing_playlist
      with_existing_work
    end

    factory :complete_playlisting, parent: :minimal_playlisting do
      with_published_post
    end
  end
end
