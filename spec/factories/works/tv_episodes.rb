FactoryBot.define do
  factory :tv_episode do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_tv_episode, class: "TvEpisode", parent: :minimal_work do; end
    factory :complete_tv_episode, class: "TvEpisode", parent: :minimal_work do; end
    factory  :stuffed_tv_episode, class: "TvEpisode", parent: :minimal_work do; end
  end
end
