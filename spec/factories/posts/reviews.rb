# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :review do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_review, class: "Review", parent: :minimal_post_parent do
      with_existing_work
    end

    factory :complete_review, class: "Review", parent: :complete_post_parent do
      with_existing_work
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :never_for_ever_album_review, parent: :minimal_review do
      body        { "It's in the trees! It's coming!" }
      association :work, factory: :kate_bush_never_for_ever
    end

    factory :unity_album_review, parent: :minimal_review do
      body        { "All those little pills! You are my angel!" }
      association :work, factory: :carl_craig_and_green_velvet_unity
    end

    factory :junior_boys_remix_review, parent: :minimal_review do
      body        { "You're back in town ..." }
      association :work, factory: :junior_boys_like_a_child_c2_remix
    end
  end
end
