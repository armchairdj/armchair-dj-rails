# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :article do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_published_post do
      published
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_article do
      with_existing_author
      with_title
    end

    factory :complete_article, parent: :minimal_article do
      with_body
      with_summary
    end
  end
end
