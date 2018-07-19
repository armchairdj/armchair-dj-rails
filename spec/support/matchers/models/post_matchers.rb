# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :be_a_populated_new_post do |param_key|
  match do |actual|
    case param_key
    when :article
      expect(actual).to be_a_new(Article)
    when :review
      expect(actual).to be_a_new(Review)
    when :mixtape
      expect(actual).to be_a_new(Mixtape)
    end

    expect(actual).to be_a_new(Post)

    expect(actual).to_not be_valid
  end

  failure_message do |actual|
    "expected #{actual} to be a populated new #{param_key}, but was not"
  end
end

RSpec::Matchers.define :be_draft do
  match do
    expect(actual.draft?      ).to eq(true)
    expect(actual.published_at).to eq(nil)
  end

  match_when_negated do |actual|
    expect(actual.draft?).to eq(false)
  end

  failure_message do |actual|
    "expected #{actual} to be draft but was not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to be draft but was"
  end
end

RSpec::Matchers.define :be_scheduled do
  match do |actual|
    expect(actual.scheduled?).to eq(true)
    expect(actual.publish_on).to be_a_kind_of(ActiveSupport::TimeWithZone)
  end

  match_when_negated do
    expect(actual.scheduled?).to eq(false)
    expect(actual.publish_on).to eq(nil)
  end

  failure_message do |actual|
    "expected #{actual} to be scheduled but was not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to be be scheduled but was"
  end
end

RSpec::Matchers.define :be_published do
  match do |actual|
    expect(actual.published?  ).to eq(true)
    expect(actual.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
  end

  match_when_negated do
    expect(actual).to be_draft
  end

  failure_message do |actual|
    "expected #{actual} to be published but was not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to be be published but was"
  end
end
