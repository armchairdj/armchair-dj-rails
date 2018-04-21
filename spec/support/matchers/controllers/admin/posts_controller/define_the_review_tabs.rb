require "rspec/expectations"

RSpec::Matchers.define :define_the_review_tabs do
  match do |actual|
    expect(assigns(:roles         )).to be_a_kind_of(Array)
    expect(assigns(:creators      )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:works         )).to be_a_kind_of(Array)

    expect(assigns(:available_tabs)).to include("post-new-work")
    expect(assigns(:available_tabs)).to include("post-choose-work")
  end

  match_when_negated do |actual|
    expect(assigns(:roles         )).to_not be_a_kind_of(Array)
    expect(assigns(:creators      )).to_not be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:works         )).to_not be_a_kind_of(Array)

    expect(assigns(:available_tabs)).to_not include("post-new-work")
    expect(assigns(:available_tabs)).to_not include("post-choose-work")
  end

  failure_message do |actual|
    "expected #{actual} to set up the review tabs, but did not"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to set up review tabs, but they did"
  end
end
