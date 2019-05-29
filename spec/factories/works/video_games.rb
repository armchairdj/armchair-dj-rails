# frozen_string_literal: true

FactoryBot.define do
  factory :video_game, class: "VideoGame" do
    factory :minimal_video_game,  class: "VideoGame", parent: :minimal_work_parent
    factory :complete_video_game, class: "VideoGame", parent: :complete_work_parent
    factory :stuffed_video_game,  class: "VideoGame", parent: :stuffed_work_parent
  end
end
