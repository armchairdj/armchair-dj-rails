# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :work do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_title do
      title { FFaker::Music.song }
    end

    trait :with_subtitle do
      subtitle "Subtitle"
    end

    trait :with_version do
      subtitle "Version"
    end

    trait :with_one_credit do
      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator).id)
      } }
    end

    trait :with_multiple_credits do
      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
        "1" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
        "2" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
      } }
    end

    trait :with_one_contribution do
      contributions_attributes { {
        "0" => attributes_for(:minimal_contribution, creator_id: create(:minimal_creator).id),
      } }
    end

    trait :with_multiple_contributions do
      contributions_attributes { {
        "0" => attributes_for(:minimal_contribution, creator_id: create(:minimal_creator).id),
        "1" => attributes_for(:minimal_contribution, creator_id: create(:minimal_creator).id),
        "2" => attributes_for(:minimal_contribution, creator_id: create(:minimal_creator).id),
      } }
    end

    trait :with_draft_post do
      after(:create) do |work|
        create(:minimal_review, :draft, work_id: work.id)

        work.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |work|
        create(:minimal_review, :scheduled, work_id: work.id)

        work.reload
      end
    end

    trait :with_published_post do
      after(:create) do |work|
        create(:minimal_review, :published, work_id: work.id)

        work.reload
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    trait :with_child do
      after(:create) do |work|
        create(:minimal_work, parent: work)

        work.reload
      end
    end

    trait :with_children do
      after(:create) do |work|
        3.times { create(:minimal_work, parent: work) }

        work.reload
      end
    end

    trait :with_specific_children do
      after(:create) do |work, evaluator|
        [evaluator.children].flatten.each do |child|
          child.update!(parent: work)
        end

        work.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_work do
      with_title
      with_one_credit
    end

    factory :complete_work do
      with_title
      with_subtitle
      with_one_credit
      with_one_contribution
    end

    factory :stuffed_work do
      with_title
      with_subtitle
      with_multiple_credits
      with_multiple_contributions
    end
  end
end
