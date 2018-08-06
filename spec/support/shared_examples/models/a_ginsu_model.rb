# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a ginsu_model" do
  # show_loads and list_loads will be defined by the caller

  let!(:collection) { described_class.where(id: ids_for_minimal_list(3)) }

  describe "self#for_list" do
    subject { collection.for_list }

    it { is_expected.to eager_load(list_loads) }

    it "contains all the records" do
      is_expected.to contain_exactly(*collection.to_a)
    end
  end

  describe "self#for_show" do
    subject { collection.for_show }

    it { is_expected.to eager_load(show_loads) }

    it "contains all the records" do
      is_expected.to contain_exactly(*collection.to_a)
    end
  end
end
