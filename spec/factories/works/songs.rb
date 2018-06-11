FactoryBot.define do
  factory :song do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_song, class: "Song", parent: :minimal_work_parent do
      factory :minimal_work do; end
    end

    factory :complete_song, class: "Song", parent: :complete_work_parent do
      factory :complete_work do; end
    end

    factory :stuffed_song, class: "Song", parent: :stuffed_work_parent do
      factory :stuffed_work do; end
    end

    ###########################################################################
    # SPECIFIC FACTORIES.
    ###########################################################################

    factory :junior_boys_like_a_child_c2_remix, parent: :complete_song do
      title "Like a Child"
      subtitle "C2 Remix"

      transient do
        creator_names     ["Junior Boys"]
        contributor_names ["Carl Craig"]
      end
    end

    factory :robyn_s_give_me_love, parent: :minimal_song do
      title "Give Me Love"
      transient { creator_names ["Robyn S"] }
    end

    factory :culture_beat_mr_vain, parent: :minimal_song do
      title "Mr. Vain"
      transient { creator_names ["Culture Beat"] }
    end

    factory :ce_ce_peniston_finally, parent: :minimal_song do
      title "Finally"
      transient { creator_names ["CeCe Peniston"] }
    end

    factory :la_bouche_be_my_lover, parent: :minimal_song do
      title "Be My Lover"
      transient { creator_names ["La Bouche"] }
    end

    factory :black_box_strike_it_up, parent: :minimal_song do
      title "Strike It Up"
      transient { creator_names ["Black Box"] }
    end
  end
end
