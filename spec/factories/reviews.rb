# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :review do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_song do
      association :work, factory: :song
    end

    trait :with_work do
      work_id { create(:minimal_work).id }
    end

    trait :with_published_publication do
      published
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_review do
      with_existing_author
      with_work
    end

    factory :complete_review, parent: :minimal_review do
      with_body
      with_summary
    end

    factory :song_review do
      with_existing_author
      with_song
    end

    factory :review_with_new_work do
      with_existing_author
      work_attributes { attributes_for(:minimal_work) }
    end

    factory :complete_review_with_new_work do
      with_existing_author
      with_body
      with_summary
      work_attributes { attributes_for(:stuffed_work) }
    end

    factory :invalid_review_with_new_work do
      with_existing_author
      work_attributes { attributes_for(:invalid_work) }
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :hounds_of_love_album_review, parent: :minimal_review do
      body        "It's in the trees! It's coming!"
      association :work, factory: :kate_bush_hounds_of_love
    end

    factory :unity_album_review, parent: :minimal_review do
      body        "All those little pills! You are my angel!"
      association :work, factory: :carl_craig_and_green_velvet_unity
    end

    factory :junior_boys_remix_review, parent: :minimal_review do
      body        "You're back in town ..."
      association :work, factory: :junior_boys_like_a_child_c2_remix
    end
  end
end
