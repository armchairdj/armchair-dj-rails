# frozen_string_literal: true

RSpec::Matchers.define :have_error do |errors_hash|
  def error_keys(actual, key)
    actual.errors.details[key].map { |h| h[:error] }
  end

  match do |actual|
    errors_hash.each { |k, v| expect(error_keys(actual, k)).to include(v) }
  end

  match_when_negated do |actual|
    errors_hash.each { |k, v| expect(error_keys(actual, k)).to_not include(v) }
  end

  failure_message do |actual|
    "expected #{actual} to have errors #{errors_hash.inspect} but did not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to have errors #{errors_hash.inspect} but did"
  end
end
