# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_alphabetizable_model" do
  context "included" do
    context "scopes" do
      pending "self#alpha"
    end

    context "hooks" do
      subject { build_minimal_instance }

      describe "after_save" do
        pending "#update_alpha"
      end
    end
  end

  context "instance" do
    subject { build_minimal_instance }

    expect(subject).to respond_to(:alpha_attributes)
  end
end
