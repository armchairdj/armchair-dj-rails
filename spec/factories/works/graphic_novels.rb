FactoryBot.define do
  factory :graphic_novel do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_graphic_novel, class: "GraphicNovel", parent: :minimal_work do; end
    factory :complete_graphic_novel, class: "GraphicNovel", parent: :minimal_work do; end
    factory  :stuffed_graphic_novel, class: "GraphicNovel", parent: :minimal_work do; end
  end
end
