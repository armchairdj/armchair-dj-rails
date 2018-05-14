require "rails_helper"

RSpec.describe Category, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_atomically_validatable_model", { name: nil } do
      subject { create(:minimal_category) }
    end
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      pending "self#eager"
      pending "self#for_admin"
      pending "self#for_site"
    end
  end

  context "associations" do
    it { should have_many(:facets) }

    it { should have_many(:media).through(:facets) }

    it { should have_many(:tags) }
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
