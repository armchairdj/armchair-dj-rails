require "ffaker"

FactoryBot.define do
  sequence :user_email    { |n| "user#{n}@example.com" }
  sequence :user_username { |n| "realcoolperson#{n}"   }

  factory :user do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_draft_post do
      role :writer

      after(:create) do |user|
        create(:minimal_post, :draft, body: "body", author: user)

        user.reload
      end
    end

    trait :with_scheduled_post do
      role :writer

      after(:create) do |user|
        create(:minimal_post, :scheduled, body: "body", author: user)

        user.reload
      end
    end

    trait :with_published_post do
      role :writer

      after(:create) do |user|
        create(:minimal_post, :published, body: "body", author: user)

        user.reload
      end
    end

    trait :with_one_of_each_post_status do
      with_draft_post
      with_scheduled_post
      with_published_post
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

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_user, parent: :member do; end

    factory :complete_user, parent: :minimal_user do
      middle_name "J."
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

    factory :root do
      role :root
      bio FFaker::HipsterIpsum.paragraphs(3).join("\n\n")
      valid
    end

    factory :confirmed_root, parent: :root do
      confirmed
    end
  end
end
