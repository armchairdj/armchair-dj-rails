require "rails_helper"

RSpec.describe Category, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_enumable_model", [:format]
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "String",
          "Year",
          "Multi",
          "Single",
        ])
      end
    end
  end

  context "scope-related" do
    context "basics" do
      pending "self#eager"
      pending "self#for_admin"
      pending "self#for_site"
    end

    context "by multi" do
      pending "self#multi"
      pending "self#single"
    end
  end

  context "associations" do
    it { should have_many(:facets) }

    it { should have_many(:media).through(:facets) }

    it { should have_many(:tags) }
  end

  context "attributes" do
    describe "format" do
      it { should define_enum_for(:format) }

      pending "self#year"
      pending "self#string"

      pending "year?"
      pending "string?"
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:name) }
  end

  context "instance" do
    pending "#display_name"

    pending "#alpha_parts"
  end
end
