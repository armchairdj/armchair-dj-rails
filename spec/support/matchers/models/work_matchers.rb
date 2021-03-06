# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :be_a_populated_new_work do
  match do |actual|
    expect(actual).to be_a_new(Work)
    expect(actual.credits).to have_at_least(3).items

    expect(actual).to_not be_valid
  end

  failure_message do |actual|
    "expected #{actual} to be a populated new work, but was not"
  end
end

RSpec::Matchers.define :be_a_fully_populated_new_work do
  match do |actual|
    expect(actual).to be_a_populated_new_work
    expect(actual.contributions).to have_at_least(10).items

    expect(actual).to_not be_valid
  end

  failure_message do |actual|
    "expected #{actual} to be a fully populated new work, but was not"
  end
end
