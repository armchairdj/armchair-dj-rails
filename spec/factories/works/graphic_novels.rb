FactoryBot.define do
  factory :graphic_novel, class: "GraphicNovel" do
    factory :minimal_graphic_novel,  class: "GraphicNovel", parent: :minimal_work_parent  do; end
    factory :complete_graphic_novel, class: "GraphicNovel", parent: :complete_work_parent do; end
    factory :stuffed_graphic_novel,  class: "GraphicNovel", parent: :stuffed_work_parent  do; end
  end
end
