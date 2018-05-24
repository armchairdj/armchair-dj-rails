# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_ancestry_model" do
  context "class" do
    subject { described_class }

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

  context "instance" do
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
end
