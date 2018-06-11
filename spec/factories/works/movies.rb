FactoryBot.define do
  factory :movie do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_movie, class: "Movie", parent: :minimal_work_parent do; end
    factory :complete_movie, class: "Movie", parent: :complete_work_parent do; end
    factory  :stuffed_movie, class: "Movie", parent: :stuffed_work_parent do; end
  end
end
