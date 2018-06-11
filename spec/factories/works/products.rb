FactoryBot.define do
  factory :product do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_product, class: "Product", parent: :minimal_work_parent do; end
    factory :complete_product, class: "Product", parent: :complete_work_parent do; end
    factory  :stuffed_product, class: "Product", parent: :stuffed_work_parent do; end
  end
end
