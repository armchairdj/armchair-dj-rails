# frozen_string_literal: true

FactoryBot.define do
  factory :album, class: "Album" do
    factory :minimal_album,  class: "Album", parent: :minimal_work_parent
    factory :complete_album, class: "Album", parent: :complete_work_parent
    factory :stuffed_album,  class: "Album", parent: :stuffed_work_parent

    factory :sleater_kinney_the_center_wont_hold, parent: :minimal_album do
      title { "The Center Won't Hold" }
      with_contributions

      milestones_attributes do
        { "0" => attributes_for(:work_milestone_for_work, year: "2019") }
      end

      transient do
        maker_names       { ["Sleater-Kinney"] }
        contributor_names { ["Corin Tucker", "Carrie Brownstein", "Janet Weiss", "St. Vincent"] }
        role_medium       { "Album" }
      end
    end

    factory :sleater_kinney_the_hot_rock, parent: :minimal_album do
      title { "The Hot Rock" }
      with_contributions

      milestones_attributes do
        { "0" => attributes_for(:work_milestone_for_work, year: "1999") }
      end

      transient do
        maker_names       { ["Sleater-Kinney"] }
        contributor_names { ["Corin Tucker", "Carrie Brownstein", "Janet Weiss", "Roger Moutenot"] }
        role_medium       { "Album" }
      end
    end

    factory :global_communications_76_14, parent: :minimal_album do
      title { "76:14" }
      with_contributions

      milestones_attributes do
        { "0" => attributes_for(:work_milestone_for_work, year: "1994") }
      end

      transient do
        maker_names       { ["Global Communication"] }
        contributor_names { ["Tom Middleton", "Mark Pritchard"] }
        role_medium       { "Album" }
      end
    end

    factory :carl_craig_and_green_velvet_unity, parent: :minimal_album do
      title { "Unity" }
      subtitle { nil }

      transient do
        maker_names { ["Carl Craig", "Green Velvet"] }
      end
    end

    factory :kate_bush_never_for_ever, parent: :minimal_album do
      title { "Never for Ever" }
      transient { maker_names { ["Kate Bush"] } }
    end

    factory :kate_bush_directors_cut, parent: :minimal_album do
      title { "Director's Cut" }
      transient { maker_names { ["Kate Bush"] } }
    end

    factory :madonna_ray_of_light, parent: :complete_album do
      title { "Ray of Light" }

      transient do
        maker_names { ["Madonna"] }
        contributor_names { ["William Orbit"] }
      end
    end
  end
end
