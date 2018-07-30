# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :have_coerced_attributes do |attributes|
  match do |actual|
    @values = {}

    attributes.each do |key, val|
      next if key.to_s.match(/password/)
      next if val.is_a?(Hash)
      next if val.respond_to?(:in_time_zone)

      @values[key] = actual.send(key)

      if val.blank?
        expect(actual.send(key)).to be_blank
      else
        expect(actual.send(key)).to eq(val.is_a?(Symbol) ? val.to_s : val)
      end
    end

    true
  end

  failure_message do |actual|
    "expected #{actual} to have coerced attributes #{attributes.inspect} but had #{@values.inspect}"
  end
end
