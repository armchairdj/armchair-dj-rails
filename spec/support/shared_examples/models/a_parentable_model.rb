# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_parentable_model" do
  context "class" do
    subject { described_class }

    context "ancestry methods" do
      it { should respond_to(:roots) }
      it { should respond_to(:ancestors_of) }
      it { should respond_to(:children_of) }
      it { should respond_to(:descendants_of) }
      it { should respond_to(:subtree_of) }
      it { should respond_to(:siblings_of) }
      it { should respond_to(:before_depth) }
      it { should respond_to(:to_depth) }
      it { should respond_to(:at_depth) }
      it { should respond_to(:from_depth) }
      it { should respond_to(:after_depth) }
      it { should respond_to(:arrange) }
    end

    context "class methods" do
      describe "self#arrange_as_array" do
        let!(:grandparent) { create_minimal_instance }
        let!(      :uncle) { create_minimal_instance(parent: grandparent) }
        let!(     :parent) { create_minimal_instance(parent: grandparent) }
        let!(    :sibling) { create_minimal_instance(parent:      parent) }
        let!(      :child) { create_minimal_instance(parent:      parent) }

        let(:ids) { [parent, uncle, grandparent, child, sibling].map(&:id) }

        subject { described_class.where(id: ids).arrange_as_array(order: :created_at) }

        it "converts result of built-in arrange method into an array" do
          should eq([grandparent, uncle, parent, sibling, child])
        end
      end
    end
  end

  context "instance" do
    context "ancestry methods" do
      subject { create_minimal_instance }

      it { should respond_to(:parent) }
      it { should respond_to(:parent_id) }
      it { should respond_to(:root) }
      it { should respond_to(:root_id) }
      it { should respond_to(:root?) }
      it { should respond_to(:is_root?) }
      it { should respond_to(:ancestors) }
      it { should respond_to(:ancestors?) }
      it { should respond_to(:ancestor_ids) }
      it { should respond_to(:path) }
      it { should respond_to(:path_ids) }
      it { should respond_to(:children) }
      it { should respond_to(:child_ids) }
      it { should respond_to(:has_parent?) }
      it { should respond_to(:ancestors?) }
      it { should respond_to(:has_children?) }
      it { should respond_to(:children?) }
      it { should respond_to(:is_childless?) }
      it { should respond_to(:childless?) }
      it { should respond_to(:siblings) }
      it { should respond_to(:sibling_ids) }
      it { should respond_to(:has_siblings?) }
      it { should respond_to(:siblings?) }
      it { should respond_to(:is_only_child?) }
      it { should respond_to(:only_child?) }
      it { should respond_to(:descendants) }
      it { should respond_to(:descendant_ids) }
      it { should respond_to(:subtree) }
      it { should respond_to(:subtree_ids) }
      it { should respond_to(:depth) }
      it { should respond_to(:parent_of?) }
      it { should respond_to(:root_of?) }
      it { should respond_to(:ancestor_of?) }
      it { should respond_to(:child_of?) }
    end

    context "parentable methods" do
      let!(:grandparent) { create_minimal_instance }
      let!(      :uncle) { create_minimal_instance(parent: grandparent) }
      let!(     :parent) { create_minimal_instance(parent: grandparent) }
      let!(    :sibling) { create_minimal_instance(parent:      parent) }
      let!(      :child) { create_minimal_instance(parent:      parent) }
      let!(    :unsaved) { build_minimal_instance }

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
end
