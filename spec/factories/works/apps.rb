# frozen_string_literal: true

FactoryBot.define do
  factory :app, class: "App" do
    factory :minimal_app,  class: "App", parent: :minimal_work_parent
    factory :complete_app, class: "App", parent: :complete_work_parent
    factory :stuffed_app,  class: "App", parent: :stuffed_work_parent
  end
end
