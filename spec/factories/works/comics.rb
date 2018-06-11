FactoryBot.define do
  factory :comic do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_comic, class: "Comic", parent: :minimal_work_parent do; end
    factory :complete_comic, class: "Comic", parent: :complete_work_parent do; end
    factory  :stuffed_comic, class: "Comic", parent: :stuffed_work_parent do; end
  end
end
