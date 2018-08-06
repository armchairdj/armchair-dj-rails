FactoryBot.define do
  factory :tv_season, class: "TvSeason" do
    factory :minimal_tv_season,  class: "TvSeason", parent: :minimal_work_parent  do; end
    factory :complete_tv_season, class: "TvSeason", parent: :complete_work_parent do; end
    factory :stuffed_tv_season,  class: "TvSeason", parent: :stuffed_work_parent  do; end
  end
end
