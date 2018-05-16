# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_the_work_dropdowns do
  match do
    expect(assigns(:categories)).to be_a_kind_of(Array)
    expect(assigns(:creators  )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:media     )).to be_a_kind_of(Array)
    expect(assigns(:roles     )).to be_a_kind_of(Array)
  end

  match_when_negated do
    expect(assigns(:categories)).to eq(nil)
    expect(assigns(:creators  )).to eq(nil)
    expect(assigns(:media     )).to eq(nil)
    expect(assigns(:roles     )).to eq(nil)
  end

  failure_message do
    "expected to prepare the work dropdowns, but did not"
  end

  failure_message_when_negated do
    "expected not to prepare the work dropdowns, but did"
  end
end
