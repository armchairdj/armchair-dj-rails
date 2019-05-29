# frozen_string_literal: true

RSpec::Matchers.define :have_aliased_method do |original, aliased|
  match do |owner|
    expected = owner.method(original.to_sym).source_location
    actual   = owner.method(aliased.to_sym).source_location

    expect(actual).to eq(expected)
  end

  failure_message do |owner|
    "expected #{owner} to alias method #{original} as #{aliased}, but did not"
  end
end
