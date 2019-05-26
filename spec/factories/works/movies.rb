# frozen_string_literal: true

FactoryBot.define do
  factory :movie, class: "Movie" do
    factory :minimal_movie,  class: "Movie", parent: :minimal_work_parent
    factory :complete_movie, class: "Movie", parent: :complete_work_parent
    factory :stuffed_movie,  class: "Movie", parent: :stuffed_work_parent
  end
end
