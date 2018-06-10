# frozen_string_literal: true

FactoryBot.define do
  trait :skip_validation do
    to_create { |instance| instance.save(validate: false) }
  end

  trait :with_existing_work do
    work_id { create(:minimal_work).id }
  end

  trait :with_author do
    association :author, factory: :admin
  end

  trait :with_existing_author do
    author_id { create(:admin).id }
  end

  trait :draft do
    # default status is :draft
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

  trait :with_title do
    title { FFaker::HipsterIpsum.phrase.titleize }
  end

  trait :with_body do
    body "Give me body!"
  end

  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first.truncate(200)
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
