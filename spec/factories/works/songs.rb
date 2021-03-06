# frozen_string_literal: true

FactoryBot.define do
  factory :song, class: "Song" do
    factory :minimal_song, class: "Song", parent: :minimal_work_parent do
      factory :minimal_work
    end

    factory :complete_song, class: "Song", parent: :complete_work_parent do
      factory :complete_work
    end

    factory :stuffed_song, class: "Song", parent: :stuffed_work_parent do
      factory :stuffed_work
    end

    factory :junior_boys_like_a_child, parent: :minimal_song do
      title { "Like a Child" }
      subtitle { "Original Version" }

      transient do
        maker_names { ["Junior Boys"] }
      end

      milestones_attributes do
        { "0" => attributes_for(:work_milestone_for_work, year: "2006") }
      end
    end

    factory :junior_boys_like_a_child_c2_remix, parent: :minimal_song do
      title { "Like a Child" }
      subtitle { "C2 Remix" }
      with_contributions

      milestones_attributes do
        { "0" => attributes_for(:work_milestone_for_work, year: "2006") }
      end

      aspect_ids do
        [
          create(:aspect, key: :song_type,     val: "Remix"),
          create(:aspect, key: :musical_genre, val: "Techno"),
          create(:aspect, key: :musical_mood,  val: "Melancholy"),
          create(:aspect, key: :music_label,   val: "Domino")
        ].map(&:id)
      end

      transient do
        maker_names       { ["Junior Boys"] }
        contributor_names { ["Carl Craig"] }
        role_medium       { "Song" }
      end
    end

    factory :junior_boys_like_a_child_c2_remix_re_edit, parent: :minimal_song do
      title { "Like a Child" }
      subtitle { "C2 Remix - Clear and Present Re-Edit" }
      with_contributions

      milestones_attributes do
        { "0" => attributes_for(:work_milestone_for_work, year: "2006") }
      end

      aspect_ids do
        [
          create(:aspect, key: :song_type,     val: "Remix"),
          create(:aspect, key: :musical_genre, val: "Techno"),
          create(:aspect, key: :musical_mood,  val: "Melancholy"),
          create(:aspect, key: :music_label,   val: "Domino")
        ].map(&:id)
      end

      transient do
        maker_names       { ["Junior Boys"] }
        contributor_names { ["Carl Craig"] }
        role_medium       { "Song" }
      end
    end
  end
end
