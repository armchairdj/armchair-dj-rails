# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  alpha                  :string
#  bio                    :text
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  middle_name            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("member"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_alpha                 (alpha)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require "ffaker"

FactoryBot.define do
  factory :user do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_draft_post do
      role :writer

      after(:create) do |user|
        create(:minimal_article, :draft, author: user)
      end
    end

    trait :with_scheduled_post do
      role :writer

      after(:create) do |user|
        create(:minimal_article, :scheduled, author: user)
      end
    end

    trait :with_published_post do
      role :writer

      after(:create) do |user|
        create(:minimal_article, :published, author: user)
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
      email      { generate(:user_email) }
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
