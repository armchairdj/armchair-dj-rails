# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :article do
    trait :with_required_fields_for_publishing do
      with_body
      with_summary
      with_hero_image
    end

    factory :minimal_article, class: "Article", parent: :minimal_post_parent do
      with_title

      factory :minimal_post
    end

    factory :complete_article, class: "Article", parent: :complete_post_parent do
      with_title

      factory :complete_post
    end
  end
end
