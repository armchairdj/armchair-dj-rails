require "rspec/expectations"

RSpec::Matchers.define :have_nillable_attributes do |attributes|
  match do |actual|
    attributes.each do |key, val|
      if val.blank?
        expect(actual.send(key)).to be_blank
      else
        expect(actual.send(key)).to eq(val)
      end
    end

    true
  end

  failure_message do |actual|
    "expected #{actual} to have nillable attributes #{attributes.inspect} but didn't"
  end
end
