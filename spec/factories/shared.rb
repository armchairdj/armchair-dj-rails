# frozen_string_literal: true

require "ffaker"

FactoryBot.define do

  sequence :aspect_name do |n|
    "Aspect #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}"
  end

  sequence :creator_name do |n|
    "#{FFaker::Music.artist}-#{n}"
  end

  sequence :link_url do |n|
    "http://www.example.com/articles/#{n}"
  end

  sequence :role_name do |n|
    "Role #{n}"
  end

  sequence :tag_name do |n|
    "tag #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}"
  end

  sequence :user_email do |n|
    "user#{n}@example.com"
  end

  sequence :user_username do |n|
    "realcoolperson#{n}"
  end

  sequence :year do |n|
    rand(1..2020)
  end

  trait :skip_validation do
    to_create { |instance| instance.save(validate: false) }
  end

  trait :with_title do
    title { FFaker::HipsterIpsum.phrase.titleize }
  end

  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first.truncate(200)
  end

  trait :with_author do
    association :author, factory: :writer
  end

  trait :draft do
    with_body
  end

  trait :scheduled do
    with_body
    publish_on { 3.weeks.from_now }
    scheduling true
  end

  trait :published do
    with_body
    publishing true
  end

  trait :with_creator do
    association :creator, factory: :minimal_creator
  end

  trait :with_work do
    association :work, factory: :minimal_song
  end

  trait :with_existing_work do
    work_id { create(:minimal_song).id }
  end

  trait :with_tags do
    transient do
      tag_count 3
    end

    tag_ids do
      tag_count.times.inject([]) { |memo, (i)| memo << create(:minimal_tag).id; memo }
    end
  end

  trait :with_links do
    links_attributes { {
      "0" => attributes_for(:link_for_linkable),
      "1" => attributes_for(:link_for_linkable),
      "2" => attributes_for(:link_for_linkable),
    } }
  end
end
