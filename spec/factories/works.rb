FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :work_title do |n|
    "Work Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :work do
    factory :minimal_work, parent: :single_creator_work do; end

    factory :work_for_contribution_factory do
      medium :song

      title { generate(:work_title) }
    end

    factory :single_creator_work do
      medium :song

      title { generate(:work_title) }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator).id)
      } }
    end

    factory :multi_creator_work do
      medium :song

      title { generate(:work_title) }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator).id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator).id)
      } }
    end

    factory :kate_bush_hounds_of_love do
      medium :album

      title "Hounds of Love"

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator, name: "Kate Bush").id),
      } }
    end

    factory :green_velvet_and_carl_craig_unity do
      medium :album

      title "Unity"

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator, name: "Green Velvet").id),
        "1" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator, name: "Carl Craig"  ).id)
      } }
    end

    factory :madonna_ray_of_light do
      medium :album

      title "Ray of Light"

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator,        creator_id: create(:minimal_creator, name: "Madonna"      ).id),
        "1" => attributes_for(:contribution, role: :music_producer, creator_id: create(:minimal_creator, name: "William Orbit").id),
      } }
    end
  end
end
