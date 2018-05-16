# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_identity_and_membership_dropdowns do
  match do
    expect(assigns(:available_pseudonyms)).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:available_real_names)).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:available_members   )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:available_groups    )).to be_a_kind_of(ActiveRecord::Relation)
  end

  match_when_negated do
    expect(assigns(:available_pseudonyms)).to eq(nil)
    expect(assigns(:available_real_names)).to eq(nil)
    expect(assigns(:available_members   )).to eq(nil)
    expect(assigns(:available_groups    )).to eq(nil)
  end

  failure_message do
    "expected to prepare the identity and membership dropdowns, but did not"
  end

  failure_message_when_negated do
    "expected not to prepare the identity and membership dropdowns, but did"
  end
end
