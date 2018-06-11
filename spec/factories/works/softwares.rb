FactoryBot.define do
  factory :software do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_software, class: "Software", parent: :minimal_work_parent do; end
    factory :complete_software, class: "Software", parent: :complete_work_parent do; end
    factory  :stuffed_software, class: "Software", parent: :stuffed_work_parent do; end
  end
end
