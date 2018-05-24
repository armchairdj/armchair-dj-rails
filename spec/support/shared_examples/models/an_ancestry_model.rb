# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_ancestry_model" do
  context "class" do
    subject { described_class }

    it { is_expected.to respond_to(:roots) }
    it { is_expected.to respond_to(:ancestors_of) }
    it { is_expected.to respond_to(:children_of) }
    it { is_expected.to respond_to(:descendants_of) }
    it { is_expected.to respond_to(:subtree_of) }
    it { is_expected.to respond_to(:siblings_of) }
    it { is_expected.to respond_to(:before_depth) }
    it { is_expected.to respond_to(:to_depth) }
    it { is_expected.to respond_to(:at_depth) }
    it { is_expected.to respond_to(:from_depth) }
    it { is_expected.to respond_to(:after_depth) }
    it { is_expected.to respond_to(:arrange) }
  end

  context "instance" do
    subject { create_minimal_instance }

    it { is_expected.to respond_to(:parent) }
    it { is_expected.to respond_to(:parent_id) }
    it { is_expected.to respond_to(:root) }
    it { is_expected.to respond_to(:root_id) }
    it { is_expected.to respond_to(:root?) }
    it { is_expected.to respond_to(:is_root?) }
    it { is_expected.to respond_to(:ancestors) }
    it { is_expected.to respond_to(:ancestors?) }
    it { is_expected.to respond_to(:ancestor_ids) }
    it { is_expected.to respond_to(:path) }
    it { is_expected.to respond_to(:path_ids) }
    it { is_expected.to respond_to(:children) }
    it { is_expected.to respond_to(:child_ids) }
    it { is_expected.to respond_to(:has_parent?) }
    it { is_expected.to respond_to(:ancestors?) }
    it { is_expected.to respond_to(:has_children?) }
    it { is_expected.to respond_to(:children?) }
    it { is_expected.to respond_to(:is_childless?) }
    it { is_expected.to respond_to(:childless?) }
    it { is_expected.to respond_to(:siblings) }
    it { is_expected.to respond_to(:sibling_ids) }
    it { is_expected.to respond_to(:has_siblings?) }
    it { is_expected.to respond_to(:siblings?) }
    it { is_expected.to respond_to(:is_only_child?) }
    it { is_expected.to respond_to(:only_child?) }
    it { is_expected.to respond_to(:descendants) }
    it { is_expected.to respond_to(:descendant_ids) }
    it { is_expected.to respond_to(:subtree) }
    it { is_expected.to respond_to(:subtree_ids) }
    it { is_expected.to respond_to(:depth) }
    it { is_expected.to respond_to(:parent_of?) }
    it { is_expected.to respond_to(:root_of?) }
    it { is_expected.to respond_to(:ancestor_of?) }
    it { is_expected.to respond_to(:child_of?) }
  end
end
