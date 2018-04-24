require "rspec/expectations"

RSpec::Matchers.define :have_coerced_attributes do |attributes|
  match do |actual|
    attributes.each do |key, val|
      next if key.to_s.match(/password/)
      next if val.is_a?(Hash)

      if val.blank?
        expect(actual.send(key)).to be_blank
      else
        val = val.to_s if val.is_a? Symbol

        expect(actual.send(key)).to eq(val)
      end
    end

    true
  end

  failure_message do |actual|
    "expected #{actual} to have coerced attributes #{attributes.inspect} but didn't"
  end
end
