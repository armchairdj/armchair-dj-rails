# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :work do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_medium do
      medium_id { create(:minimal_medium).id }
    end

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
        create(:review, :draft, work_id: work.id)

        work.reload
      end
    end

    trait :with_scheduled_post do
      after(:create) do |work|
        create(:review, :scheduled, work_id: work.id)

        work.reload
      end
    end

    trait :with_published_post do
      after(:create) do |work|
        create(:review, :published, work_id: work.id)

        work.reload
      end
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :song, parent: :minimal_work do
      medium_id { create(:song_medium).id }
    end

    factory :album, parent: :minimal_work do
      medium_id { create(:album_medium).id }
    end

    factory :invalid_work do
      with_medium
      with_title
    end

    factory :minimal_work do
      with_medium
      with_title
      with_one_credit
    end

    factory :complete_work, parent: :minimal_work do
      with_medium
      with_title
      with_one_credit
      with_one_contribution
    end

    factory :stuffed_work, parent: :minimal_work do
      with_medium
      with_title
      with_multiple_credits
      with_multiple_contributions
    end

    factory :global_communications_76_14, parent: :album do
      title "76:14"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Global Communication").id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, :with_role, creator_id: create(:minimal_creator, name: "Tom Middleton" ).id),
        "1" => attributes_for(:contribution, :with_role, creator_id: create(:minimal_creator, name: "Mark Pritchard").id)
      } }
    end

    factory :carl_craig_and_green_velvet_unity, parent: :album do
      title  "Unity"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Green Velvet").id),
        "1" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Carl Craig"  ).id)
      } }
    end

    factory :kate_bush_hounds_of_love, parent: :album do
      title "Hounds of Love"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:kate_bush).id),
      } }
    end

    factory :kate_bush_directors_cut, parent: :album do
      title "Director's Cut"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:kate_bush).id),
      } }
    end

    factory :madonna_ray_of_light, parent: :album do
      title  "Ray of Light"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Madonna").id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, :with_role, creator_id: create(:minimal_creator, name: "William Orbit").id),
      } }
    end

    factory :junior_boys_like_a_child_c2_remix, parent: :song do
      title "Like a Child"
      subtitle "C2 Remix"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Junior Boys").id)
      } }

      contributions_attributes { {
        "0" => attributes_for(:contribution, :with_role, creator_id: create(:minimal_creator, name: "Carl Craig" ).id),
      } }
    end

    factory :robyn_s_give_me_love, parent: :song do
      title "Give Me Love"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Robyn S").id)
      } }
    end

    factory :culture_beat_mr_vain, parent: :song do
      title "Mr. Vain"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Culture Beat").id)
      } }
    end

    factory :ce_ce_peniston_finally, parent: :song do
      title "Finally"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "CeCe Peniston").id)
      } }
    end

    factory :la_bouche_be_my_lover, parent: :song do
      title "Be My Lover"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "La Bouche").id)
      } }
    end

    factory :black_box_strike_it_up, parent: :song do
      title "Strike It Up"

      credits_attributes { {
        "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Black Box").id)
      } }
    end
  end
end
