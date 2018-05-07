# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :be_a_populated_new_medium do
  match do |actual|
    expect(actual       ).to be_a_new(Medium)
    expect(actual.roles ).to have(10).items
    expect(actual.facets).to have(10).items

    expect(actual).to_not be_valid
  end

  failure_message do |actual|
    "expected #{actual} to be a populated new medium, but was not"
  end
end
