# frozen_string_literal: true

FactoryBot.define do
  factory :graphic_novel, class: "GraphicNovel" do
    factory :minimal_graphic_novel,  class: "GraphicNovel", parent: :minimal_work_parent
    factory :complete_graphic_novel, class: "GraphicNovel", parent: :complete_work_parent
    factory :stuffed_graphic_novel,  class: "GraphicNovel", parent: :stuffed_work_parent
  end
end
