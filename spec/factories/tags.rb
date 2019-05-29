# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_alpha  (alpha)
#

FactoryBot.define do
  factory :tag do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:tag_name) }
    end

    trait :with_draft_post do
      after(:create) do |tag|
        create(:minimal_article, :draft, tag_ids: [tag.id])
      end
    end

    trait :with_scheduled_post do
      after(:create) do |tag|
        create(:minimal_article, :scheduled, tag_ids: [tag.id])
      end
    end

    trait :with_published_post do
      after(:create) do |tag|
        create(:minimal_article, :published, tag_ids: [tag.id])
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_tag do
      with_name
    end
  end
end
