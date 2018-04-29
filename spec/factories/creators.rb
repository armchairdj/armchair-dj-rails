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
          "credits_attributes" => {
            "0" => attributes_for(:credit, creator_id: creator.id)
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
          "credits_attributes" => {
            "0" => attributes_for(:credit, creator_id: creator.id)
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
          "credits_attributes" => {
            "0" => attributes_for(:credit, creator_id: creator.id)
          }
        })

        creator.reload
      end
    end

    trait :with_one_of_each_post_status do
      after(:create) do |creator|
        create(:song_review, :draft, work_attributes: attributes_for(:song).merge({ credits_attributes: {
          "0" => attributes_for(:credit, creator_id: creator.id)
        }}))

        create(:song_review, :scheduled, work_attributes: attributes_for(:song).merge({ credits_attributes: {
          "0" => attributes_for(:credit, creator_id: creator.id)
        }}))

        create(:song_review, :published, work_attributes: attributes_for(:song).merge({ credits_attributes: {
          "0" => attributes_for(:credit, creator_id: creator.id)
        }}))

        creator.reload
      end
    end

    trait :with_new_pseudonym do
      primary

      identities_attributes { {
        "0" => { "pseudonym_id" => create(:musician, :secondary).id }
      } }
    end

    trait :with_pseudonym do
      primary

      after(:create) do |creator|
        create(:minimal_identity, creator: creator)
      end
    end

    trait :with_specific_pseudonyms do
      primary

      after(:create) do |creator, evaluator|
        [evaluator.pseudonyms].flatten.each do |pseudonym|
          create(:minimal_identity, creator: creator, pseudonym: pseudonym)
        end
      end
    end

    trait :with_new_member do
      collective

      memberships_attributes { {
        "0" => { "member_id" => create(:musician, :singular).id }
      } }
    end

    trait :with_member do
      collective

      after(:create) do |creator|
        create(:minimal_membership, creator: creator)
      end
    end

    trait :with_specific_members do
      collective

      after(:create) do |creator, evaluator|
        [evaluator.members].flatten.each do |member|
          create(:minimal_membership, creator: creator, member: member)
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
      primary
      singular
      name "Kate Bush"
    end

    factory :volfgang_voigt do
      primary
      singular
      name "Wolfgang Voigt"

      factory :volfgang_voigt_with_pseudonyms do
        transient do
          pseudonyms { [create(:gas) ] }
        end

        with_specific_pseudonyms
      end
    end

    factory :gas do
      secondary
      singular
      name "Gas"
    end

    factory :dbx do
      secondary
      singular
      name "DBX"
    end

    factory :the_kooky_scientist do
      secondary
      singular
      name "The Kooky Scientist"
    end

    factory :plastikman do
      secondary
      singular
      name "Plastikman"
    end

    factory :fuse do
      secondary
      singular
      name "F.U.S.E."
    end

    factory :richie_hawtin do
      primary
      singular
      name "Richie Hawtin"

      factory :richie_hawtin_with_pseudonyms do
        transient do
          pseudonyms { [create(:plastikman), create(:fuse) ] }
        end

        with_specific_pseudonyms
      end
    end

    factory :dan_bell do
      primary
      singular
      name "Dan Bell"

      factory :dan_bell_with_pseudonyms do
        transient do
          pseudonyms { [create(:dbx) ] }
        end

        with_specific_pseudonyms
      end
    end

    factory :fred_giannelli do
      primary
      singular
      name "Fred Giannelli"

      factory :fred_giannelli_with_pseudonyms do
        transient do
          pseudonyms { [create(:the_kooky_scientist) ] }
        end

        with_specific_pseudonyms
      end
    end

    factory :spawn do
      primary
      collective
      name "Spawn"

      factory :spawn_with_members do
        transient do
          members { [create(:fred_giannelli), create(:richie_hawtin), create(:dan_bell) ] }
        end

        with_specific_members
      end
    end

    factory :stevie_nicks do
      primary
      singular
      name "Stevie Nicks"
    end

    factory :lindsay_buckingham do
      primary
      singular
      name "Lindsay Buckingham"
    end

    factory :christine_mcvie do
      primary
      singular
      name "Christine McVie"
    end

    factory :john_mcvie do
      primary
      singular
      name "John McVie"
    end

    factory :mick_fleetwood do
      primary
      singular
      name "Mick Fleetwood"
    end

    factory :fleetwood_mac do
      primary
      collective
      name "Fleetwood Mac"

      factory :fleetwood_mac_with_members do
        transient do
          members do
            [
              create(:mick_fleetwood),
              create(:john_mcvie),
              create(:christine_mcvie),
              create(:stevie_nicks),
              create(:lindsay_buckingham)
            ]
          end
        end

        with_specific_members
      end
    end
  end
end
