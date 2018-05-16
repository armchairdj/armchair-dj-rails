# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_the_work_dropdowns do
  match do
    expect(assigns(:media     )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:categories)).to be_a_kind_of(Array)
    expect(assigns(:creators  )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:roles     )).to be_a_kind_of(ActiveRecord::Relation)
  end

  failure_message do
    "expected to prepare the work dropdowns, but did not"
  end
end

RSpec::Matchers.define :prepare_only_the_media_dropdown do
  match do
    expect(assigns(:media     )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:categories)).to eq(nil)
    expect(assigns(:creators  )).to eq(nil)
    expect(assigns(:roles     )).to eq(nil)
  end

  failure_message do
    "expected to prepare only the media dropdown, but did not"
  end
end
