FactoryBot.define do
  factory :app do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_app, class: "App", parent: :minimal_work_parent do; end
    factory :complete_app, class: "App", parent: :complete_work_parent do; end
    factory  :stuffed_app, class: "App", parent: :stuffed_work_parent do; end
  end
end
