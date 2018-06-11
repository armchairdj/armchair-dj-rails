FactoryBot.define do
  factory :publication do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_publication, class: "Publication", parent: :minimal_work_parent do; end
    factory :complete_publication, class: "Publication", parent: :complete_work_parent do; end
    factory  :stuffed_publication, class: "Publication", parent: :stuffed_work_parent do; end
  end
end
