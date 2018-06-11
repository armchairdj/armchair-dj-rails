FactoryBot.define do
  factory :hardware do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_hardware, class: "Hardware", parent: :minimal_work_parent do; end
    factory :complete_hardware, class: "Hardware", parent: :complete_work_parent do; end
    factory  :stuffed_hardware, class: "Hardware", parent: :stuffed_work_parent do; end
  end
end
