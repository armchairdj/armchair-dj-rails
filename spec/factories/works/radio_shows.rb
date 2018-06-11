FactoryBot.define do
  factory :radio_show do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_radio_show, class: "RadioShow", parent: :minimal_work_parent do; end
    factory :complete_radio_show, class: "RadioShow", parent: :complete_work_parent do; end
    factory  :stuffed_radio_show, class: "RadioShow", parent: :stuffed_work_parent do; end
  end
end
