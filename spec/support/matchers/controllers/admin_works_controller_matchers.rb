# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_the_complete_form do
  match do
    expect(assigns(:media   )).to be_a_kind_of(Array)
    expect(assigns(:creators)).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:roles   )).to be_a_kind_of(ActiveRecord::Relation)
  end

  failure_message do
    "expected to prepare the work dropdowns, but did not"
  end
end

RSpec::Matchers.define :prepare_the_initial_form do
  match do
    expect(assigns(:media   )).to be_a_kind_of(Array)
    expect(assigns(:creators)).to eq(nil)
    expect(assigns(:roles   )).to eq(nil)
  end

  failure_message do
    "expected to prepare only the types dropdown, but did not"
  end
end
