# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :creator do
    factory :minimal_creator, parent: :musician do; end

    ###########################################################################
    # TRAITS.
    ###########################################################################

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
  end
end
