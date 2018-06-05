# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_acts_as_list_model" do |top_of_list, scope|
  context "configuration" do
    # :one and :two defined by caller as scoped acts_as_list_collections

    it "respects scope" do
      expect(one.maximum(:position)).to eq(top_of_list == 1 ? one.length : one.length - 1)
      expect(two.maximum(:position)).to eq(top_of_list == 1 ? one.length : one.length - 1)
    end

    it "respects top_of_list" do
      expect(one.minimum(:position)).to eq(top_of_list)
      expect(two.minimum(:position)).to eq(top_of_list)
    end
  end

  context "class" do
    subject { described_class }

    it { is_expected.to respond_to(:acts_as_list_no_update) }
  end

  context "instance" do
    subject { create_minimal_instance }

    it { is_expected.to respond_to(:insert_at) }
    it { is_expected.to respond_to(:move_lower) }
    it { is_expected.to respond_to(:move_higher) }
    it { is_expected.to respond_to(:move_to_bottom) }
    it { is_expected.to respond_to(:move_to_top) }
    it { is_expected.to respond_to(:remove_from_list) }
    it { is_expected.to respond_to(:increment_position) }
    it { is_expected.to respond_to(:decrement_position) }
    it { is_expected.to respond_to(:set_list_position) }
    it { is_expected.to respond_to(:first?) }
    it { is_expected.to respond_to(:last?) }
    it { is_expected.to respond_to(:in_list?) }
    it { is_expected.to respond_to(:not_in_list?) }
    it { is_expected.to respond_to(:default_position?) }
    it { is_expected.to respond_to(:higher_item) }
    it { is_expected.to respond_to(:higher_items) }
    it { is_expected.to respond_to(:lower_item) }
    it { is_expected.to respond_to(:lower_items) }
  end
end
