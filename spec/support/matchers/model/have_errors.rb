# frozen_string_literal: true

RSpec::Matchers.define :have_error do |*args|
  def error_keys(actual, key)
    actual.errors.details[key].map { |h| h[:error] }
  end

  def normalized(args)
    return args.first if args.length == 1

    hash = {}
    hash[args.first] = args.last
    hash
  end

  match do |actual|
    normalized(args).each { |k, v| expect(error_keys(actual, k)).to include(v) }
  end

  match_when_negated do |actual|
    normalized(args).each { |k, v| expect(error_keys(actual, k)).to_not include(v) }
  end

  description do
    "have errors #{normalized(args).inspect}"
  end

  failure_message do |actual|
    "expected #{actual} to have errors #{normalized(args).inspect} but did not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to have errors #{normalized(args).inspect} but did"
  end
end
