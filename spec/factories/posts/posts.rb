# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :post do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_body do
      body "Give me body!"
    end

    trait :with_published_post do
      published
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_post_parent do
      with_existing_author
    end

    factory :complete_post_parent, parent: :minimal_post_parent do
      with_body
      with_summary
    end
  end
end
