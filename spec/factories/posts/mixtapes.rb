# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  ###########################################################################
  # TRAITS.
  ###########################################################################

  trait :with_playlist do
    playlist_id { create(:minimal_playlist).id }
  end

  trait :with_complete_playlist do
    playlist_id { create(:complete_playlist).id }
  end

  factory :mixtape do
    factory :minimal_mixtape, class: "Mixtape", parent: :minimal_post_parent do
      with_playlist
    end

    factory :complete_mixtape, class: "Mixtape", parent: :complete_post_parent do
      with_playlist
    end
  end
end
