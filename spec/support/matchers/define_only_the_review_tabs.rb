require "rspec/expectations"

RSpec::Matchers.define :define_only_the_review_tabs do

  match do |actual|
    expect(assigns).to     define_the_review_tabs
    expect(assigns).to_not define_the_standalone_tab
  end

  failure_message do |actual|
    "expected instance variables to set up only the review tabs, but they did not"
  end
end
