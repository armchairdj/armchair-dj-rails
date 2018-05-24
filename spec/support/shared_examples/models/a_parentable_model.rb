# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_parentable_model" do
  let(:grandparent) { create_minimal_instance }
  let(      :uncle) { create_minimal_instance(parent: grandparent) }
  let(     :parent) { create_minimal_instance(parent: grandparent) }
  let(    :sibling) { create_minimal_instance(parent:      parent) }
  let(      :child) { create_minimal_instance(parent:      parent) }
  let(    :unsaved) { build_minimal_instance }

  context "concerns" do
    it_behaves_like "an_ancestry_model"
  end

  context "class" do
    subject { described_class }

    describe "self#arrange_as_array" do
      let!(:ids) { [grandparent, uncle, parent, sibling, child].map(&:id) }

      subject { described_class.where(id: ids).arrange_as_array(order: :created_at) }

      it "converts result of built-in arrange method into an array" do
        is_expected.to eq([grandparent, uncle, parent, sibling, child])
      end
    end
  end

  context "instance" do
    subject { create_minimal_instance }

    let!(:ids) { [grandparent, uncle, parent, sibling, child].map(&:id) }

    describe "#parent_dropdown_options" do
      describe "includes all saved instances except self and own descendants" do
        specify { expect(grandparent.parent_dropdown_options(:created_at)).to eq([]) }
        specify { expect(    unsaved.parent_dropdown_options(:created_at)).to eq([grandparent, uncle, parent, sibling, child]) }
        specify { expect(      uncle.parent_dropdown_options(:created_at)).to eq([grandparent, parent, sibling, child]) }
        specify { expect(     parent.parent_dropdown_options(:created_at)).to eq([grandparent, uncle]) }
        specify { expect(    sibling.parent_dropdown_options(:created_at)).to eq([grandparent, uncle, parent, child]) }
        specify { expect(      child.parent_dropdown_options(:created_at)).to eq([grandparent, uncle, parent, sibling]) }
      end
    end
  end
end
