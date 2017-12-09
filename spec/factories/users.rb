FactoryBot.define do
  sequence :user_first_name do |n|
    "Firstname#{n}"
  end

  sequence :user_last_name do |n|
    "Lastname#{n}"
  end

  sequence :user_email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    factory :guest do
      first_name { generate(:user_first_name) }
      last_name  { generate(:user_first_name) }
      role       :guest
      email      { generate(:user_email) }
      password   "password1234"

      factory :minimal_user do end

      factory :confirmed_guest do
        confirmed_at Time.now
      end

      factory :member do
        role :member

        factory :confirmed_member do
          confirmed_at Time.now
        end
      end

      factory :contributor do
        role :contributor

        factory :confirmed_contributor do
          confirmed_at Time.now
        end
      end

      factory :admin do
        role :admin

        factory :confirmed_admin do
          confirmed_at Time.now
        end
      end
    end
  end
end
