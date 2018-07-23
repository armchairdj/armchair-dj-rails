# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_the_edit_post_form do |param_key|
  match do
    if param_key == :review
      expect(assigns(:works)).to be_a_kind_of(Array)
    elsif param_key == :mixtape
      expect(assigns(:playlists)).to be_a_kind_of(ActiveRecord::Relation)
    end

    expect(assigns(:tags)).to be_a_kind_of(ActiveRecord::Relation)
  end

  failure_message do
    "expected to prepare the #{param_key} form, but did not"
  end
end
