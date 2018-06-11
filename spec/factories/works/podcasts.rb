FactoryBot.define do
  factory :podcast do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_podcast, class: "Podcast", parent: :minimal_work do; end
    factory :complete_podcast, class: "Podcast", parent: :minimal_work do; end
    factory  :stuffed_podcast, class: "Podcast", parent: :minimal_work do; end
  end
end
