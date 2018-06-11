FactoryBot.define do
  factory :radio_show do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_radio_show, class: "RadioShow", parent: :minimal_work do; end
    factory :complete_radio_show, class: "RadioShow", parent: :minimal_work do; end
    factory  :stuffed_radio_show, class: "RadioShow", parent: :minimal_work do; end
  end
end
