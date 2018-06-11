FactoryBot.define do
  factory :album do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_album, class: "Album", parent: :minimal_work do; end
    factory :complete_album, class: "Album", parent: :minimal_work do; end
    factory  :stuffed_album, class: "Album", parent: :minimal_work do; end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

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
  end
end
