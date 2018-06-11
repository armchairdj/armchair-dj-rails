FactoryBot.define do
  factory :publication do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_publication, class: "Publication", parent: :minimal_work do; end
    factory :complete_publication, class: "Publication", parent: :minimal_work do; end
    factory  :stuffed_publication, class: "Publication", parent: :minimal_work do; end
  end
end
