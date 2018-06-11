FactoryBot.define do
  factory :link do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_url do
      url { generate(:link_url) }
    end

    trait :with_description do
      description "link description"
    end

    trait :with_creator do
      association :linkable, factory: :minimal_creator
    end

    trait :with_article do
      association :linkable, factory: :minimal_article
    end

    trait :with_work do
      association :linkable, factory: :minimal_song
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_link, parent: :creator_link

    factory :creator_link do
      with_url
      with_description
      with_creator
    end

    factory :article_link do
      with_url
      with_description
      with_article
    end

    factory :work_link do
      with_url
      with_description
      with_work
    end
  end
end
