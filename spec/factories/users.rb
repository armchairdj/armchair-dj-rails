require "ffaker"

FactoryBot.define do
  sequence :user_email    { |n| "user#{n}@example.com" }
  sequence :user_username { |n| "realcoolperson#{n}"   }

  factory :user do
    factory :minimal_user, parent: :member do; end

    factory :complete_user, parent: :minimal_user do
      middle_name "J."
    end

    trait :valid do
      first_name { FFaker::Name.first_name }
      last_name  { FFaker::Name.last_name }
      email      { generate(:user_email   ) }
      username   { generate(:user_username) }
      password   "password1234"
    end

    trait :confirmed do
      confirmed_at DateTime.now
    end

    factory :member do
      role :member
      valid
    end

    factory :confirmed_member, parent: :member do
      confirmed
    end

    factory :writer do
      role :writer
      bio FFaker::HipsterIpsum.paragraphs(3).join("\n\n")
      valid
    end

    factory :confirmed_writer, parent: :writer do
      confirmed
    end

    factory :editor do
      role :editor
      bio FFaker::HipsterIpsum.paragraphs(3).join("\n\n")
      valid
    end

    factory :confirmed_editor, parent: :editor do
      confirmed
    end

    factory :admin do
      role :admin
      bio FFaker::HipsterIpsum.paragraphs(3).join("\n\n")
      valid
    end

    factory :confirmed_admin, parent: :admin do
      confirmed
    end

    factory :super_admin do
      role :super_admin
      bio FFaker::HipsterIpsum.paragraphs(3).join("\n\n")
      valid
    end

    factory :confirmed_super_admin, parent: :super_admin do
      confirmed
    end
  end
end
