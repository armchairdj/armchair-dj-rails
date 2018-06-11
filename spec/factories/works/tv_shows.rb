FactoryBot.define do
  factory :tv_show do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_tv_show, class: "TvShow", parent: :minimal_work do; end
    factory :complete_tv_show, class: "TvShow", parent: :minimal_work do; end
    factory  :stuffed_tv_show, class: "TvShow", parent: :minimal_work do; end
  end
end
