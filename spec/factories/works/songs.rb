FactoryBot.define do
  factory :song, class: "Song" do

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

    factory :junior_boys_like_a_child_c2_remix, parent: :minimal_song do
      title "Like a Child"
      subtitle "C2 Remix"
      with_contributions

      milestones_attributes { {
        "0" => attributes_for(:work_milestone_for_work, year: "2006")
      } }

      aspect_ids { [
        create(:aspect, facet: :song_type,     name: "Remix"     ).id,
        create(:aspect, facet: :musical_genre, name: "Techno"    ).id,
        create(:aspect, facet: :musical_mood,  name: "Melancholy").id,
        create(:aspect, facet: :music_label,   name: "Domino"    ).id,
      ] }

      transient do
        maker_names       ["Junior Boys"]
        contributor_names ["Carl Craig"]
        role_medium       "Song"
      end
    end
  end
end
