FactoryBot.define do
  factory :tv_season do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_tv_season, class: "TvSeason", parent: :minimal_work do; end
    factory :complete_tv_season, class: "TvSeason", parent: :minimal_work do; end
    factory  :stuffed_tv_season, class: "TvSeason", parent: :minimal_work do; end
  end
end
