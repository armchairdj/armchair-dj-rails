# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_eager_loadable_model" do
  # show_loads and list_loads will be defined by the caller

  let!(:ids) { 3.times.map { create_minimal_instance.id } }
  let!(:collection) { described_class.where(id: ids) }

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
