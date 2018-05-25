# frozen_string_literal: true

RSpec.shared_examples "an_admin_controller" do
  let(:model_instance) { create_minimal_instance }

  context "included" do
    context "callbacks" do
      pending "verify_authorized"
    end
  end

  context "instance" do
    context "private" do
      describe "#determine_layout" do
        subject { controller.send(:determine_layout) }

        it { is_expected.to eq("admin") }
      end

      pending "#scoped_and_sorted_collection"
    end
  end
end
