# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :mixtape do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_playlist do
      playlist_id { create(:minimal_playlist).id }
    end

    trait :with_published_publication do
      published
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_mixtape do
      with_existing_author
      with_playlist
    end

    factory :complete_mixtape, parent: :minimal_mixtape do
      with_body
      with_summary
    end
  end
end
