# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_acts_as_list_model" do
  context "configuration" do
    pending "respects scope"
    pending "respects top_of_list"
  end

  context "class" do
    subject { described_class }

    it { should respond_to(:acts_as_list_no_update) }
  end

  context "instance" do
    subject { create_minimal_instance }

    it { should respond_to(:insert_at) }
    it { should respond_to(:move_lower) }
    it { should respond_to(:move_higher) }
    it { should respond_to(:move_to_bottom) }
    it { should respond_to(:move_to_top) }
    it { should respond_to(:remove_from_list) }
    it { should respond_to(:increment_position) }
    it { should respond_to(:decrement_position) }
    it { should respond_to(:set_list_position) }
    it { should respond_to(:first?) }
    it { should respond_to(:last?) }
    it { should respond_to(:in_list?) }
    it { should respond_to(:not_in_list?) }
    it { should respond_to(:default_position?) }
    it { should respond_to(:higher_item) }
    it { should respond_to(:higher_items) }
    it { should respond_to(:lower_item) }
    it { should respond_to(:lower_items) }
  end
end
