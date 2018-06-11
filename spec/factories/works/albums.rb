FactoryBot.define do
  factory :album do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_album, class: "Album", parent: :minimal_work_parent do; end
    factory :complete_album, class: "Album", parent: :complete_work_parent do; end
    factory  :stuffed_album, class: "Album", parent: :stuffed_work_parent do; end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :global_communications_76_14, parent: :complete_album do
      title "76:14"

      transient do
        creator_count     1
        creator_names     ["Global Communication"]
        contributor_count 2
        contributor_names ["Tom Middleton", "Mark Pritchard"]
      end
    end

    factory :carl_craig_and_green_velvet_unity, parent: :complete_album do
      title  "Unity"
      subtitle nil

      transient do
        creator_count 2
        creator_names ["Green Velvet", "Carl Craig"]
      end
    end

    factory :kate_bush_never_for_ever, parent: :minimal_album do
      title "Never for Ever"
      transient { creator_names ["Kate Bush"] }
    end

    factory :kate_bush_directors_cut, parent: :minimal_album do
      title "Director's Cut"
      transient { creator_names ["Kate Bush"] }
    end

    factory :madonna_ray_of_light, parent: :complete_album do
      title  "Ray of Light"

      transient do
        creator_names     ["Madonna"]
        contributor_names ["William Orbit"]
      end
    end
  end
end
