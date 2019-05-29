# frozen_string_literal: true

# == Schema Information
#
# Table name: playlist_tracks
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
#  index_playlist_tracks_on_playlist_id  (playlist_id)
#  index_playlist_tracks_on_work_id      (work_id)
#

FactoryBot.define do
  factory :playlist_track, class: "Playlist::Track" do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_existing_playlist do
      playlist_id { create(:minimal_playlist).id }
    end

    trait :with_draft_post do
      after(:create) do |track|
        create(:review, :draft, author_id: track.playlist.author.id, work_id: track.work.id)
      end
    end

    trait :with_scheduled_post do
      after(:create) do |track|
        create(:review, :scheduled, author_id: track.playlist.author.id, work_id: track.work.id)
      end
    end

    trait :with_published_post do
      after(:create) do |track|
        create(:minimal_review, :published, author_id: track.playlist.author.id, work_id: track.work.id)
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_playlist_track do
      with_existing_playlist
      with_existing_work
    end

    factory :complete_playlist_track, parent: :minimal_playlist_track do
      with_published_post
    end
  end
end
