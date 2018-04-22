require "rspec/expectations"

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

RSpec::Matchers.define :be_draft do
  match do
    expect(actual.published?  ).to eq(false)
    expect(actual.published_at).to eq(nil)
  end

  match_when_negated do |actual|
    expect(actual).to be_published
  end

  failure_message do |actual|
    "expected #{actual} to be draft but was not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to be draft but was"
  end
end

RSpec::Matchers.define :be_a_populated_new_post do
  match do |actual|
    expect(actual                          ).to be_a_new(Post)
    expect(actual.work                     ).to be_a_new(Work)
    expect(actual.work.contributions.length).to eq(10)

    expect(actual).to_not be_valid
  end

  failure_message do |actual|
    "expected #{actual} not to be draft but was"
  end
end