# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_displayable_model" do
  subject { create_minimal_instance }

  describe "sluggable methods" do
    let(:unviewable) { create_minimal_instance }
    let(  :viewable) { create_minimal_instance(:with_published_post) }

    describe "#slug_locked?" do
      specify { expect(unviewable.send(:slug_locked?)).to eq(false) }
      specify { expect(  viewable.send(:slug_locked?)).to eq(true ) }
    end

    describe "#validate_slug_presence?" do
      specify { expect(unviewable.send(:validate_slug_presence?)).to eq(false) }
      specify { expect(  viewable.send(:validate_slug_presence?)).to eq(true ) }
    end
  end
end
