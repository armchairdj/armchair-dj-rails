FactoryBot.define do
  factory :comic do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_comic, class: "Comic", parent: :minimal_work do; end
    factory :complete_comic, class: "Comic", parent: :minimal_work do; end
    factory  :stuffed_comic, class: "Comic", parent: :minimal_work do; end
  end
end
