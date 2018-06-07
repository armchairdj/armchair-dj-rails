# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :post do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_published_post do
      published
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_post do
      with_existing_author
      with_title
    end

    factory :complete_post, parent: :minimal_post do
      with_body
      with_summary
    end
  end
end
