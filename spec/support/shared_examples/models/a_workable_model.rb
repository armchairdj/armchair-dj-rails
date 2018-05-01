# frozen_string_literal: true

RSpec.shared_examples "a_workable_model" do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"
  end

  context "included" do
    context "scope-related" do
      pending "viewable"
      pending "eager"
      pending "for_admin"
      pending "for_site"
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
