# frozen_string_literal: true

FactoryBot.define do
  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first.truncate(200)
  end

  trait :with_one_of_each_post_status do
    with_draft_post
    with_scheduled_post
    with_published_post
  end
end
