# frozen_string_literal: true

FactoryBot.define do
  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first.truncate(200)
  end

  trait :skip_validate do
    to_create { |instance| instance.save(validate: false) }
  end
end
