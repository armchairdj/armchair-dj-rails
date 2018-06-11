# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :article do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_article, class: "Article", parent: :minimal_post_parent do
      with_title
    end

    factory :complete_article, class: "Article", parent: :complete_post_parent do
      with_title
    end

    factory :minimal_post,  parent: :minimal_article  do; end
    factory :complete_post, parent: :complete_article do; end
  end
end
