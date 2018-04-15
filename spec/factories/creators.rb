require 'ffaker'

FactoryBot.define do
  factory :creator do
    factory :minimal_creator, parent: :musician do; end

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_draft_post do
      after(:create) do |creator|
        create(:song_review, :draft, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          '0' => attributes_for(:contribution, role: :creator, creator_id: creator.id)
        }}))

        creator.reload
      end
    end

    trait :with_published_post do
      after(:create) do |creator|
        create(:song_review, :published, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          '0' => attributes_for(:contribution, role: :creator, creator_id: creator.id)
        }}))

        creator.reload
      end
    end

    trait :with_published_post_and_draft_post do
      after(:create) do |creator|
        create(:song_review, :draft, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          '0' => attributes_for(:contribution, role: :creator, creator_id: creator.id)
        }}))

        create(:song_review, :published, work_attributes: attributes_for(:song).merge({ contributions_attributes: {
          '0' => attributes_for(:contribution, role: :creator, creator_id: creator.id)
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
  end
end
