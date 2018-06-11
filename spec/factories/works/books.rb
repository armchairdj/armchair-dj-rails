FactoryBot.define do
  factory :book do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_book, class: "Book", parent: :minimal_work do; end
    factory :complete_book, class: "Book", parent: :minimal_work do; end
    factory  :stuffed_book, class: "Book", parent: :minimal_work do; end
  end
end
