require "ffaker"

FactoryBot.define do
  sequence :user_email { |n| "user#{n}@example.com" }

  factory :user do
    factory :minimal_user, parent: :member do; end

    trait :valid do
      first_name { FFaker::Name.first_name }
      last_name  { FFaker::Name.last_name }
      email      { generate(:user_email) }
      password   "password1234"
    end

    trait :confirmed do
      confirmed_at Time.now
    end

    factory :member do
      role :member
      valid
    end

    factory :confirmed_member, parent: :member do
      confirmed
    end

    factory :contributor do
      role :contributor
      valid
    end

    factory :confirmed_contributor, parent: :contributor do
      confirmed
    end

    factory :admin do
      role :admin
      valid
    end

    factory :confirmed_admin, parent: :admin do
      confirmed
    end
  end
end
