require "rspec/expectations"

RSpec::Matchers.define :define_the_standalone_tab do
  match do |actual|
    expect(assigns(:available_tabs)).to include("post-standalone")
  end

  match_when_negated do |actual|
    expect(assigns(:available_tabs)).to_not include("post-standalone")
  end

  failure_message do |actual|
    "expected #{actual} to set up the standalone tab, but did not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to set up standalone tab, but they did"
  end
end