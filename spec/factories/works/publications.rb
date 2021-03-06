# frozen_string_literal: true

FactoryBot.define do
  factory :publication, class: "Publication" do
    factory :minimal_publication,  class: "Publication", parent: :minimal_work_parent
    factory :complete_publication, class: "Publication", parent: :complete_work_parent
    factory :stuffed_publication,  class: "Publication", parent: :stuffed_work_parent
  end
end
