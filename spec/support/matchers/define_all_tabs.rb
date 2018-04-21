require "rspec/expectations"

RSpec::Matchers.define :define_all_tabs do

  match do |actual|
    expect(assigns).to define_the_review_tabs
    expect(assigns).to define_the_standalone_tab
  end

  failure_message do |actual|
    "expected instance variables to set up all three tabs, but they did not"
  end
end
