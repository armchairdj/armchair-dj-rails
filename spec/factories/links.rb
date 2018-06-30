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

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_url do
      url { generate(:link_url) }
    end

    trait :with_description do
      description "link description"
    end

    trait :with_creator do
      association :linkable, factory: :minimal_creator
    end

    trait :with_article do
      association :linkable, factory: :minimal_article
    end

    trait :with_work do
      association :linkable, factory: :minimal_song
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_link, parent: :creator_link

    factory :creator_link do
      with_url
      with_description
      with_creator
    end

    factory :article_link do
      with_url
      with_description
      with_article
    end

    factory :work_link do
      with_url
      with_description
      with_work
    end
  end
end
