# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#
# Indexes
#
#  index_playlists_on_alpha  (alpha)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#

FactoryBot.define do
  factory :playlist do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_2_tracks do
      tracks_attributes do
        { "0" => attributes_for(:playlist_track, :with_existing_work),
          "1" => attributes_for(:playlist_track, :with_existing_work) }
      end
    end

    trait :with_10_tracks do
      tracks_attributes do
        { "0" => attributes_for(:playlist_track, :with_existing_work),
          "1" => attributes_for(:playlist_track, :with_existing_work),
          "2" => attributes_for(:playlist_track, :with_existing_work),
          "3" => attributes_for(:playlist_track, :with_existing_work),
          "4" => attributes_for(:playlist_track, :with_existing_work),
          "5" => attributes_for(:playlist_track, :with_existing_work),
          "6" => attributes_for(:playlist_track, :with_existing_work),
          "7" => attributes_for(:playlist_track, :with_existing_work),
          "8" => attributes_for(:playlist_track, :with_existing_work),
          "9" => attributes_for(:playlist_track, :with_existing_work) }
      end
    end

    trait :with_draft_post do
      after(:create) do |playlist|
        create(:minimal_mixtape, :draft, author_id: playlist.author.id, playlist_id: playlist.id)
      end
    end

    trait :with_scheduled_post do
      after(:create) do |playlist|
        create(:minimal_mixtape, :scheduled, author_id: playlist.author.id, playlist_id: playlist.id)
      end
    end

    trait :with_published_post do
      after(:create) do |playlist|
        create(:minimal_mixtape, :published, author_id: playlist.author.id, playlist_id: playlist.id)
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_playlist do
      with_title
      with_author
      with_2_tracks
    end

    factory :complete_playlist, parent: :minimal_playlist do
      with_10_tracks
    end
  end
end
