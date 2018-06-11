FactoryBot.define do
  factory :video_game do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_video_game, class: "VideoGame", parent: :minimal_work_parent do; end
    factory :complete_video_game, class: "VideoGame", parent: :complete_work_parent do; end
    factory  :stuffed_video_game, class: "VideoGame", parent: :stuffed_work_parent do; end
  end
end
