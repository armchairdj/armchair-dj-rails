require 'ffaker'

FactoryBot.define do
  factory :post do
    factory :minimal_post, parent: :standalone_post do; end

    factory :standalone_post do
      title { FFaker::HipsterIpsum.unique.phrase }
      body "This is a standalone post about, like, deep thoughts."
    end

    factory :review_post do
      body "This is a review."
      association :work, factory: :minimal_work
    end

    factory :hounds_of_love_album_review do
      body "It's in the trees! It's coming!"
      association :work, factory: :kate_bush_hounds_of_love
    end
  end
end
