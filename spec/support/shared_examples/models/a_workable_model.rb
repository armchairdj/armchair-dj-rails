# frozen_string_literal: true

RSpec.shared_examples "a_workable_model" do
  context "included" do
    context "scope-related" do
      pending "alpha"
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
      it { should validate_presence_of(:work   ) }
      it { should validate_presence_of(:creator) }
    end
  end
end
