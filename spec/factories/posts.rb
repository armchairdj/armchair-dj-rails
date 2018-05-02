# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :post do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_author do
      association :author, factory: :admin
    end

    trait :with_title do
      title { FFaker::HipsterIpsum.phrase.titleize }
    end

    trait :with_body do
      body "This is a post body."
    end

    trait :with_work do
      association :work, factory: :song
    end

    trait :draft do
      # default status is :draft
    end

    trait :scheduled do
      publish_on 3.weeks.from_now

      after(:create) do |post, evaluator|
        raise AASM::InvalidTransition unless post.schedule!

        post.reload
      end
    end

    trait :published do
      after(:create) do |post, evaluator|
        raise AASM::InvalidTransition unless post.publish!

        post.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_post, parent: :standalone_post do; end

    factory :standalone_post do
      with_title
      with_author
      with_body
    end

    factory :review do
      with_work
      with_author
      with_body
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :hounds_of_love_album_review, parent: :review do
      body        "It's in the trees! It's coming!"
      association :work, factory: :kate_bush_hounds_of_love
    end

    factory :unity_album_review, parent: :review do
      body        "All those little pills! You are my angel!"
      association :work, factory: :carl_craig_and_green_velvet_unity
    end

    factory :junior_boys_remix_review, parent: :review do
      body        "You're back in town ..."
      association :work, factory: :junior_boys_like_a_child_c2_remix
    end

    factory :tiny_standalone_post, parent: :standalone_post do
      title "Hello"
      body  "It me."
    end
  end
end
