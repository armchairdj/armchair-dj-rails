FactoryBot.define do
  factory :software do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_software, class: "Software", parent: :minimal_work do; end
    factory :complete_software, class: "Software", parent: :minimal_work do; end
    factory  :stuffed_software, class: "Software", parent: :minimal_work do; end
  end
end
