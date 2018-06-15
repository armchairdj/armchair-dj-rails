# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :creator do
    name nil
    initialize_with { Creator.find_or_initialize_by(name: name) }

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_draft_post do
      after(:create) do |creator|
        work = create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:credit, creator_id: creator.id)
        })

        create(:minimal_review, :draft, work_id: work.id)

        creator.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |creator|
        work = create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:credit, creator_id: creator.id)
        })

        create(:minimal_review, :scheduled, work_id: work.id)

        creator.reload
      end
    end

    trait :with_published_post do
      after(:create) do |creator|
        work = create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:credit, creator_id: creator.id)
        })

        create(:minimal_review, :published, work_id: work.id)

        creator.reload
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
    end

    trait :primary do
      primary true
    end

    trait :secondary do
      primary false
    end

    trait :individual do
      individual true
    end

    trait :collective do
      individual false
    end

    trait :with_new_pseudonym do
      primary

      pseudonym_identities_attributes { {
        "0" => { "pseudonym_id" => create(:minimal_creator, :secondary).id }
      } }
    end

    trait :with_pseudonym do
      primary

      after(:create) do |creator|
        create(:minimal_identity, real_name: creator)

        creator.reload
      end
    end

    trait :with_specific_pseudonyms do
      primary

      after(:create) do |creator, evaluator|
        [evaluator.pseudonyms].flatten.each do |pseudonym|
          create(:minimal_identity, real_name: creator, pseudonym: pseudonym)
        end

        creator.reload
      end
    end

    trait :with_new_real_name do
      secondary

      real_name_identities_attributes { {
        "0" => { "real_name_id" => create(:minimal_creator, :primary).id }
      } }
    end

    trait :with_real_name do
      secondary

      after(:create) do |creator|
        create(:minimal_identity, pseudonym: creator)

        creator.reload
      end
    end

    trait :with_specific_real_names do
      secondary

      after(:create) do |creator, evaluator|
        [evaluator.real_names].flatten.each do |real_name|
          create(:minimal_identity, pseudonym: creator, real_name: real_name)
        end

        creator.reload
      end
    end

    trait :with_new_member do
      collective

      member_memberships_attributes { {
        "0" => { "member_id" => create(:minimal_creator, :individual).id }
      } }
    end

    trait :with_member do
      collective

      after(:create) do |creator|
        create(:minimal_membership, group: creator)

        creator.reload
      end
    end

    trait :with_specific_members do
      collective

      after(:create) do |creator, evaluator|
        [evaluator.members].flatten.each do |member|
          create(:minimal_membership, group: creator, member: member)
        end

        creator.reload
      end
    end

    trait :with_new_group do
      individual

      group_memberships_attributes { {
        "0" => { "group_id" => create(:minimal_creator, :collective).id }
      } }
    end

    trait :with_group do
      individual

      after(:create) do |creator|
        create(:minimal_membership, member: creator)

        creator.reload
      end
    end

    trait :with_specific_group do
      individual

      after(:create) do |creator, evaluator|
        [evaluator.groups].flatten.each do |group|
          create(:minimal_membership, member: creator, group: group)
        end

        creator.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_creator do
      name { generate(:creator_name) }
    end

    factory :complete_creator, parent: :minimal_creator do
      with_summary
    end

    factory :primary_creator, parent: :minimal_creator do
      primary
    end

    factory :secondary_creator, parent: :minimal_creator do
      secondary
    end

    factory :individual_creator, parent: :minimal_creator do
      individual
    end

    factory :collective_creator, parent: :minimal_creator do
      collective
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :kate_bush do
      primary
      individual
      name "Kate Bush"
    end

    factory :wolfgang_voigt do
      primary
      individual
      name "Wolfgang Voigt"

      factory :wolfgang_voigt_with_pseudonyms do
        transient do
          pseudonyms { [create(:gas) ] }
        end

        with_specific_pseudonyms
      end
    end

    factory :gas do
      secondary
      individual
      name "Gas"
    end

    factory :dbx do
      secondary
      individual
      name "DBX"
    end

    factory :the_kooky_scientist do
      secondary
      individual
      name "The Kooky Scientist"
    end

    factory :plastikman do
      secondary
      individual
      name "Plastikman"
    end

    factory :fuse do
      secondary
      individual
      name "F.U.S.E."
    end

    factory :robotman do
      secondary
      individual
      name "Robotman"
    end

    factory :richie_hawtin do
      primary
      individual
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
      individual
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
      individual
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

      factory :complete_spawn do
        transient do
          members { [
            create(:fred_giannelli_with_pseudonyms),
            create(:richie_hawtin_with_pseudonyms),
            create(:dan_bell_with_pseudonyms)
          ] }
        end

        with_specific_members
      end
    end

    factory :stevie_nicks do
      primary
      individual
      name "Stevie Nicks"
    end

    factory :lindsay_buckingham do
      primary
      individual
      name "Lindsay Buckingham"
    end

    factory :christine_mcvie do
      primary
      individual
      name "Christine McVie"
    end

    factory :john_mcvie do
      primary
      individual
      name "John McVie"
    end

    factory :mick_fleetwood do
      primary
      individual
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
