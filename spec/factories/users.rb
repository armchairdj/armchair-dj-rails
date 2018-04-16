require "ffaker"

FactoryBot.define do
  sequence :user_email { |n| "user#{n}@example.com" }

  factory :user do
    factory :minimal_user, parent: :member do end

    trait :valid do
      first_name { FFaker::Name.first_name }
      last_name  { FFaker::Name.last_name }
      email      { generate(:user_email) }
      password   'password1234'
    end

    trait :confirmed do
      confirmed_at Time.now
    end

    factory :member do
      valid
      role :member
    end

    factory :confirmed_member, parent: :member do
      confirmed
    end

    factory :contributor do
      valid
      role :contributor
    end

    factory :confirmed_contributor, parent: :contributor do
      confirmed
    end

    factory :admin do
      valid
      role :admin
    end

    factory :confirmed_admin, parent: :admin do
      confirmed
    end
  end
end
