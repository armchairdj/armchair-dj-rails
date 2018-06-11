FactoryBot.define do
  factory :tv_episode do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_tv_episode, class: "TvEpisode", parent: :minimal_work_parent do; end
    factory :complete_tv_episode, class: "TvEpisode", parent: :complete_work_parent do; end
    factory  :stuffed_tv_episode, class: "TvEpisode", parent: :stuffed_work_parent do; end
  end
end
