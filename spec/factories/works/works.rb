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

    trait :with_credits do
      transient do
        creator_names { [generate(:creator_name)] }

        creator_count 1
      end

      credits_attributes do
        creator_count.times.inject({}) do |memo, (i)|
          name    = creator_names[i] || generate(:creator_name)
          creator = create(:minimal_creator, name: name)

          memo[i.to_s] = attributes_for(:minimal_credit, creator_id: creator.id); memo
        end
      end
    end

    trait :with_contributions do
      transient do
        contributor_names { [generate(:creator_name)] }

        contributor_count 1
      end

      after(:create) do |work, evaluator|
        evaluator.contributor_count.times do |i|
          creator = create(:minimal_creator, name: evaluator.contributor_names[i] || generate(:creator_name))
          role    = create(:minimal_role, work_type: work.type)
          contrib = create(:minimal_contribution, work_id: work.id, creator_id: creator.id, role_id: role.id)

          work.reload
        end
      end
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

    trait :with_children do
      transient do
        child_count 1
      end

      after(:create) do |work, evaluator|
        evaluator.child_count.times { create(:minimal_work, parent: work) }

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

    trait :with_specific_creator do
      transient do
        specific_creator nil
      end

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: specific_creator.id)
      } }
    end

    trait :with_specific_contributor do
      transient do
        specific_contributor nil
      end

      contributions_attributes { {
        "0" => attributes_for(:contribution, role_id: create(:minimal_role).id, creator_id: specific_contributor.id)
      } }
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_work_parent do
      with_title
      with_credits
    end

    factory :complete_work_parent, parent: :minimal_work_parent do
      with_subtitle
      with_contributions
    end

    factory :stuffed_work_parent, parent: :complete_work_parent do
      transient do
        creator_count 3
        contributor_count 3
      end
    end
  end
end
