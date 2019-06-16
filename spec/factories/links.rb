# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id            :bigint(8)        not null, primary key
#  description   :string
#  linkable_type :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  linkable_id   :bigint(8)
#
# Indexes
#
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#

FactoryBot.define do
  factory :link do
    trait :with_url do
      url { generate(:link_url) }
    end

    trait :with_description do
      description { "link description" }
    end

    trait :with_article do
      association :linkable, factory: :minimal_article
    end

    trait :with_review do
      association :linkable, factory: :minimal_review
    end

    trait :with_mixtape do
      association :linkable, factory: :minimal_mixtape
    end

    trait :with_user do
      association :linkable, factory: :writer
    end

    factory :minimal_link, parent: :article_link

    factory :link_for_linkable do
      with_url
      with_description
    end

    factory :article_link do
      with_url
      with_description
      with_article
    end

    factory :review_link do
      with_url
      with_description
      with_review
    end

    factory :mixtape_link do
      with_url
      with_description
      with_mixtape
    end

    factory :user_link do
      with_url
      with_description
      with_user
    end
  end
end
