require "rspec/expectations"

RSpec::Matchers.define :define_only_the_standalone_tab do

  match do |actual|
    expect(assigns).to     define_the_standalone_tab
    expect(assigns).to_not define_the_review_tabs

    expect(assigns(:selected_tab)).to eq("post-standalone")
  end

  failure_message do |actual|
    "expected instance variables to set up only the standalone tab, but they did not"
  end
end
