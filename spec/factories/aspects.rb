# frozen_string_literal: true

# == Schema Information
#
# Table name: aspects
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  key        :integer          not null
#  val        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_aspects_on_alpha  (alpha)
#  index_aspects_on_key    (key)
#

FactoryBot.define do
  factory :aspect do
    key { nil }
    val { nil }
    initialize_with { Aspect.find_or_initialize_by(key: key, val: val) }

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_key do
      key { :song_type }
    end

    trait :with_val do
      val { generate(:aspect_val) }
    end

    trait :with_work do
      after(:create) do |aspect|
        create(:minimal_song, aspect_ids: [aspect.id])
      end
    end

    trait :with_draft_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :draft, work_id: aspect.works.first.id)
      end
    end

    trait :with_scheduled_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :scheduled, work_id: aspect.works.first.id)
      end
    end

    trait :with_published_post do
      with_work

      after(:create) do |aspect|
        create(:minimal_review, :published, work_id: aspect.works.first.id)
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

    factory :minimal_aspect do
      with_key
      with_val
    end
  end
end
