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
  end
end
