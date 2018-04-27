# frozen_string_literal: true

RSpec::Matchers.define :have_errors do |errors_hash|
  match do |actual|
    errors_hash.each do |key, val|
      expect(actual.errors.details[key]).to include({ error: val })
    end
  end

  match_when_negated do |actual|
    errors_hash.each do |key, val|
      expect(actual.errors.details[key]).to_not include({ error: val })
    end
  end

  failure_message do |actual|
    "expected #{actual} to have errors #{errors_hash.inspect} but did not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to have errors #{errors_hash.inspect} but did"
  end
end
