require "rspec/expectations"

RSpec::Matchers.define :define_only_the_review_tabs do

  match do |actual|
    expect(assigns).to     define_the_review_tabs
    expect(assigns).to_not define_the_standalone_tab
    expect(assigns(:selected_tab)).to eq(@selected) if @selected
  end

  chain :and_select do |selected|
    @selected = selected
  end

  failure_message do |actual|
    if @selected
      "expected #{actual} to set up only the review tabs and select #{@selected}, but did not"
    else
      "expected #{actual} to set up only the review tabs, but did not"
    end
  end
end
