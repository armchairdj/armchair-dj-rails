FactoryBot.define do
  factory :video_game do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_video_game, class: "VideoGame", parent: :minimal_work do; end
    factory :complete_video_game, class: "VideoGame", parent: :minimal_work do; end
    factory  :stuffed_video_game, class: "VideoGame", parent: :minimal_work do; end
  end
end
