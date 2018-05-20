FactoryBot.define do
  sequence :link_url do |n|
    "http://www.example.com/posts/#{n}"
  end

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

    trait :with_post do
      association :linkable, factory: :minimal_post
    end

    trait :with_work do
      association :linkable, factory: :minimal_work
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

    factory :post_link do
      with_url
      with_description
      with_post
    end

    factory :work_link do
      with_url
      with_description
      with_work
    end
  end
end
