FactoryBot.define do
  factory :movie do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_movie, class: "Movie", parent: :minimal_work do; end
    factory :complete_movie, class: "Movie", parent: :minimal_work do; end
    factory  :stuffed_movie, class: "Movie", parent: :minimal_work do; end
  end
end
