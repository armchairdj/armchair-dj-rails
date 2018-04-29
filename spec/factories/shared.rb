# frozen_string_literal: true

FactoryBot.define do
  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first.truncate(200)
  end
end
