# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :be_a_populated_new_creator do
  match do |actual|
    expect(actual).to be_a_new(Creator)
    expect(actual.pseudonym_identities).to have(5).items
    expect(actual.real_name_identities).to have(1).items
    expect(actual.member_memberships).to have(5).items
    expect(actual.group_memberships).to have(5).items

    expect(actual).to_not be_valid
  end

  failure_message do |actual|
    "expected #{actual} to be a populated new creator, but was not"
  end
end
