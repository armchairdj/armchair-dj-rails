# frozen_string_literal: true

RSpec.shared_examples "a_workable_model" do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"
  end

  context "included" do
    context "scope-related" do
      describe "self#eager" do
        subject { described_class.eager }

        specify { should eager_load(:work, :creator) }
      end

      describe "self#viewable" do
        specify { should_not eager_load(:work, :creator) }
      end

      describe "self#for_admin" do
        specify { should eager_load(:work, :creator) }
      end

      describe "self#for_site" do
        specify { should eager_load(:work, :creator) }
      end
    end

    context "associations" do
      it { should belong_to(:creator) }
      it { should belong_to(:work   ) }
    end

    context "validations" do
      subject { create_minimal_instance }

      it { should validate_presence_of(:creator) }
      it { should validate_presence_of(:work   ) }
    end
  end
end
