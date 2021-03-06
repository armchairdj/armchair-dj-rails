# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :post do
    trait :with_body do
      body { "Give me body!" }
    end

    trait :with_published_post do
      published
    end

    factory :minimal_post_parent do
      with_author
    end

    factory :complete_post_parent, parent: :minimal_post_parent do
      with_body
      with_summary
      with_links
      with_tags
    end
  end
end
