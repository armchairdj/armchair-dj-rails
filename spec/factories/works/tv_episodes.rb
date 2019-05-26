# frozen_string_literal: true

FactoryBot.define do
  factory :tv_episode, class: "TvEpisode" do
    factory :minimal_tv_episode,  class: "TvEpisode", parent: :minimal_work_parent
    factory :complete_tv_episode, class: "TvEpisode", parent: :complete_work_parent
    factory :stuffed_tv_episode,  class: "TvEpisode", parent: :stuffed_work_parent
  end
end
