FactoryBot.define do
  factory :hardware do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_hardware, class: "Hardware", parent: :minimal_work do; end
    factory :complete_hardware, class: "Hardware", parent: :minimal_work do; end
    factory  :stuffed_hardware, class: "Hardware", parent: :minimal_work do; end
  end
end
