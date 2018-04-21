require "rspec/expectations"

RSpec::Matchers.define :define_the_review_tabs do
  match do
    expect(assigns(:roles         )).to be_a_kind_of(Array)
    expect(assigns(:creators      )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:works         )).to be_a_kind_of(Array)

    expect(assigns(:available_tabs)).to include("post-new-work")
    expect(assigns(:available_tabs)).to include("post-choose-work")
  end

  match_when_negated do
    expect(assigns(:roles         )).to_not be_a_kind_of(Array)
    expect(assigns(:creators      )).to_not be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:works         )).to_not be_a_kind_of(Array)

    expect(assigns(:available_tabs)).to_not include("post-new-work")
    expect(assigns(:available_tabs)).to_not include("post-choose-work")
  end

  failure_message do
    "expected to set up the review tabs, but did not"
  end

  failure_message_when_negated do
    "expected not to set up review tabs, but they did"
  end
end

RSpec::Matchers.define :define_the_standalone_tab do
  match do
    expect(assigns(:available_tabs)).to include("post-standalone")
  end

  match_when_negated do
    expect(assigns(:available_tabs)).to_not include("post-standalone")
  end

  failure_message do
    "expected to set up the standalone tab, but did not"
  end

  failure_message_when_negated do
    "expected not to set up standalone tab, but they did"
  end
end

RSpec::Matchers.define :define_only_the_review_tabs do
  match do
    expect(assigns).to     define_the_review_tabs
    expect(assigns).to_not define_the_standalone_tab
    expect(assigns(:selected_tab)).to eq(@selected) if @selected
  end

  chain :and_select do |selected|
    @selected = selected
  end

  failure_message do
    if @selected
      "expected to set up only the review tabs and select #{@selected}, but did not"
    else
      "expected to set up only the review tabs, but did not"
    end
  end
end

RSpec::Matchers.define :define_only_the_standalone_tab do
  match do
    expect(assigns).to     define_the_standalone_tab
    expect(assigns).to_not define_the_review_tabs
    expect(assigns(:selected_tab)).to eq("post-standalone")
  end

  failure_message do
    "expected to set up only the standalone tab, but did not"
  end
end

RSpec::Matchers.define :define_all_tabs do
  match do
    expect(assigns).to define_the_review_tabs
    expect(assigns).to define_the_standalone_tab
    expect(assigns(:selected_tab)).to eq(@selected) if @selected
  end

  chain :and_select do |selected|
    @selected = selected
  end

  failure_message do
    if @selected
      "expected to set up all three tabs and select #{@selected}, but did not"
    else
      "expected to set up all three tabs, but did not"
    end
  end
end
