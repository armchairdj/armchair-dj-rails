FactoryBot.define do
  factory :song do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_song, parent: :minimal_work do; end
    factory :complete_song, parent: :minimal_work do; end
    factory  :stuffed_song, parent: :minimal_work do; end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

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
