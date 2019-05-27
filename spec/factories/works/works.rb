# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  trait :with_milestone do
    transient do
      release_year "1972"
    end

    milestones_attributes do
      { "0" => attributes_for(:work_milestone, activity: :released, year: release_year) }
    end
  end

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

    trait :with_credits do
      transient do
        maker_names []

        maker_count 1
      end

      credits_attributes do
        [maker_count, maker_names.length].max.times.each_with_object({}) do |(i), memo|
          name    = maker_names[i] || generate(:creator_name)
          creator = create(:minimal_creator, name: name)

          memo[i.to_s] = attributes_for(:minimal_credit, creator_id: creator.id); 
        end
      end
    end

    trait :with_contributions do
      transient do
        contributor_names []

        contributor_count 1

        role_medium "Song"
      end

      contributions_attributes do
        [contributor_count, contributor_names.length].max.times.each_with_object({}) do |(i), memo|
          name    = maker_names[i] || generate(:creator_name)
          role    = create(:minimal_role, medium: role_medium)
          creator = create(:minimal_creator, name: name)

          memo[i.to_s] = attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator.id); 
        end
      end
    end

    trait :with_draft_post do
      after(:create) do |work|
        create(:minimal_review, :draft, work_id: work.id)
      end
    end

    trait :with_scheduled_post do
      after(:create) do |work|
        create(:minimal_review, :scheduled, work_id: work.id)
      end
    end

    trait :with_published_post do
      after(:create) do |work|
        create(:minimal_review, :published, work_id: work.id)
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    trait :with_children do
      transient do
        child_count 1
      end

      after(:create) do |work, evaluator|
        evaluator.child_count.times { create(:minimal_work, parent: work) }
      end
    end

    trait :with_specific_children do
      after(:create) do |work, evaluator|
        [*evaluator.children].each do |child|
          child.update!(parent: work)
        end
      end
    end

    trait :with_specific_creator do
      transient do
        specific_creator nil
      end

      credits_attributes do
        { "0" => attributes_for(:credit, creator_id: specific_creator.id) }
      end
    end

    trait :with_specific_contributor do
      transient do
        specific_contributor nil
      end

      contributions_attributes do
        { "0" => attributes_for(:contribution, role_id: create(:minimal_role).id, creator_id: specific_contributor.id) }
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_work_parent do
      with_title
      with_credits
      with_milestone
    end

    factory :complete_work_parent, parent: :minimal_work_parent do
      with_subtitle
      with_contributions
    end

    factory :stuffed_work_parent, parent: :complete_work_parent do
      transient do
        maker_count 3
        contributor_count 3
      end
    end
  end
end
