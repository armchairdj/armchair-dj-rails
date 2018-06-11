FactoryBot.define do
  factory :podcast do

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory  :minimal_podcast, class: "Podcast", parent: :minimal_work_parent do; end
    factory :complete_podcast, class: "Podcast", parent: :complete_work_parent do; end
    factory  :stuffed_podcast, class: "Podcast", parent: :stuffed_work_parent do; end
  end
end
