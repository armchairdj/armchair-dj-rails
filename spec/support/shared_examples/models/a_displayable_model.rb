# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_displayable_model" do
  subject { create_minimal_instance }

  it_behaves_like "a_linkable_model"

  it_behaves_like "a_sluggable_model"

  it_behaves_like "a_summarizable_model"

  it_behaves_like "a_viewable_model"

  pending "#slug_locked?"
  pending "#should_validate_slug_presence?"
end
