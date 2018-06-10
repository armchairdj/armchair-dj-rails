# frozen_string_literal: true

FactoryBot.define do

  sequence :aspect_name    { |n| "Aspect #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }
  sequence :category_name  { |n| "Category #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }
  sequence :link_url       { |n| "http://www.example.com/articles/#{n}" }
  sequence :medium_name    { |n| "Medium #{n}" }
  sequence :role_name      { |n| "Role #{n}" }
  sequence :tag_name       { |n| "tag #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}" }
  sequence :user_email     { |n| "user#{n}@example.com" }
  sequence :user_username  { |n| "realcoolperson#{n}"   }
  sequence :year           { |n| rand(1..2020) }

  trait :skip_validation do
    to_create { |instance| instance.save(validate: false) }
  end

  trait :with_title do
    title { FFaker::HipsterIpsum.phrase.titleize }
  end

  trait :with_body do
    body "Give me body!"
  end

  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first.truncate(200)
  end

  trait :with_existing_author do
    author_id { create(:admin).id }
  end

  trait :draft do
    with_body
  end

  trait :scheduled do
    with_body
    publish_on 3.weeks.from_now

    after(:create) do |instance, evaluator|
      raise StandardError("could not schedule: #{instance.errors.inspect}") unless instance.schedule!

      instance.reload
    end
  end

  trait :published do
    with_body

    after(:create) do |instance, evaluator|
      raise StandardError.new("could not publish: #{instance.errors.inspect}") unless instance.publish!

      instance.reload
    end
  end

  trait :with_existing_work do
    transient do
      work_title { FFaker::Music.song }
    end

    work_id { create(:minimal_work, title: work_title).id }
  end

  trait :with_existing_category do
    transient do
      name_for_category { generate(:category_name) }
    end

    category_id { create(:minimal_category, name: name_for_category).id }
  end

  trait :with_tags do
    transient do
      tag_count 3
    end

    tag_ids do
      tag_count.times.inject([]) { |memo, (i)| memo << create(:minimal_tag).id; memo }
    end
  end
end
