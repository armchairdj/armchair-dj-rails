FactoryBot.define do
  factory :product do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_product, class: "Product", parent: :minimal_work do; end
    factory :complete_product, class: "Product", parent: :minimal_work do; end
    factory  :stuffed_product, class: "Product", parent: :minimal_work do; end
  end
end
