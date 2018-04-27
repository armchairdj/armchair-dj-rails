# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :creator do
    factory :minimal_creator, parent: :musician do; end

    factory :primary_creator, parent: :minimal_creator do
      primary
    end

    factory :secondary_creator, parent: :minimal_creator do
      secondary
    end

    factory :collective_creator, parent: :minimal_creator do
      collective
    end

    factory :singular_creator, parent: :minimal_creator do
      singular
    end

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :primary do
      primary true
    end

    trait :secondary do
      primary false
    end

    trait :collective do
      collective true
    end

    trait :singular do
      collective false
    end

    trait :with_draft_post do
      after(:create) do |creator|
        create(:post, :with_author, :draft, body: "body", work_attributes: {
          "title"                    => "#{FFaker::Music.song}",
          "medium"                   => "song",
          "contributions_attributes" => {
            "0" => attributes_for(:contribution, role: :creator, creator_id: creator.id)
          }
        })

        creator.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |creator|
        create(:post, :with_author, :scheduled, body: "body", work_attributes: {
          "title"                    => "#{FFaker::Music.song}",
          "medium"                   => "song",
          "contributions_attributes" => {
            "0" => attributes_for(:contribution, role: :creator, creator_id: creator.id)
          }
        })

        creator.reload
      end
    end

    trait :with_published_post do
      after(:create) do |creator|
        create(:post, :with_author, :published, body: "body", work_attributes: {
          "title"                    => "#{FFaker::Music.song}",
          "medium"                   => "song",
          "contributions_attributes" => {
            "0" => attributes_for(:contribution, role: :creator, creator_id: creator.id)
          }
        })

        creator.reload
      end
    end

    trait :with_one_of_each_post_status do
      after(:create) do |creator|
        create(:song_review, :draft, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          "0" => attributes_for(:contribution, role: :creator, creator_id: creator.id)
        }}))

        create(:song_review, :scheduled, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          "0" => attributes_for(:contribution, role: :creator, creator_id: creator.id)
        }}))

        create(:song_review, :published, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          "0" => attributes_for(:contribution, role: :creator, creator_id: creator.id)
        }}))

        creator.reload
      end
    end

    trait :with_named do
      after(:create) do |creator|
        create(:named_participation, creator: creator)
      end
    end

    trait :with_has_name do
      after(:create) do |creator|
        create(:has_name_participation, creator: creator)
      end
    end

    trait :with_member_of do
      after(:create) do |creator|
        create(:member_of_participation, creator: creator)
      end
    end

    trait :with_has_member do
      after(:create) do |creator|
        create(:has_member_participation, creator: creator)
      end
    end

    trait :with_specific_named do
      after(:create) do |creator, evaluator|
        [evaluator.named].flatten.each do |participant|
          create(:named_participation, creator: creator, participant: participant)
        end
      end
    end

    trait :with_specific_has_name do
      after(:create) do |creator, evaluator|
        [evaluator.has_name].flatten.each do |participant|
          create(:has_name_participation, creator: creator, participant: participant)
        end
      end
    end

    trait :with_specific_member_of do
      after(:create) do |creator, evaluator|
        [evaluator.member_of].flatten.each do |participant|
          create(:member_of_participation, creator: creator, participant: participant)
        end
      end
    end

    trait :with_specific_has_member do
      after(:create) do |creator, evaluator|
        [evaluator.has_member].flatten.each do |participant|
          create(:has_member_participation, creator: creator, participant: participant)
        end
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :musician do
      name { FFaker::Music.artist }
    end

    factory :director do
      name { FFaker::Name.name }
    end

    factory :showrunner do
      name { FFaker::Name.name }
    end

    factory :radio_host do
      name { FFaker::Name.name }
    end

    factory :podcaster do
      name { FFaker::Name.name }
    end

    factory :author do
      name { FFaker::Name.name }
    end

    factory :cartoonist do
      name { FFaker::Name.name }
    end

    factory :publisher do
      name { FFaker::Name.name }
    end

    factory :artist do
      name { FFaker::Name.name }
    end

    factory :game_platform do
      name { FFaker::Product.brand }
    end

    factory :software_platform do
      name { FFaker::Product.brand }
    end

    factory :hardware_company do
      name { FFaker::Product.brand }
    end

    factory :brand do
      name { FFaker::Product.brand }
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :kate_bush do
      name "Kate Bush"
    end

    factory :richie_hawtin do
      name "Richie Hawtin"

      transient do
        named     { [create(:plastikman), create(:fuse) ] }
        member_of { create(:spawn) }
      end

      with_specific_named
      with_specific_member_of
    end

    factory :dan_bell do
      name "Dan Bell"

      transient do
        named     { create(:dbx) }
        member_of { create(:spawn) }
      end

      with_specific_named
      with_specific_member_of
    end

    factory :dbx do
      name "DBX"
    end

    factory :fred_giannelli do
      name "Fred Giannelli"

      transient do
        named     { create(:dbx) }
        member_of { create(:spawn) }
      end

      with_specific_named
      with_specific_member_of
    end

    factory :the_kooky_scientist do
      name "The Kooky Scientist"
    end

    factory :plastikman do
      name "Plastikman"
    end

    factory :spawn do
      name "Spawn"
    end

    factory :fuse do
      name "F.U.S.E."
    end
  end
end
