# frozen_string_literal: true

FactoryBot.define do
  factory :podcast, class: "Podcast" do
    factory :minimal_podcast,  class: "Podcast", parent: :minimal_work_parent
    factory :complete_podcast, class: "Podcast", parent: :complete_work_parent
    factory :stuffed_podcast,  class: "Podcast", parent: :stuffed_work_parent
  end
end
