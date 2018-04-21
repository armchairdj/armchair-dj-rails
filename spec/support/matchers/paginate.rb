require "rspec/expectations"

RSpec::Matchers.define :paginate do |displayed|
  match do |actual|
    expect(actual.size       ).to eq(displayed)
    expect(actual.total_count).to eq(@total)
  end

  chain :of_total do |total|
    @total = total
  end

  chain :records do; end

  failure_message do |actual|
    "expected #{actual} to display #{displayed} records out of #{@total}, but it didn't"
  end
end
