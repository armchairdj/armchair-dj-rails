require "rails_helper"

RSpec.describe Role, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    pending "grouped_options"
  end

  context "scope-related" do
    pending "self#eager"
    pending "self#for_admin"
  end

  context "associations" do
    it { should belong_to(:medium) }

    it { should have_many(:contributions) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:medium) }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name).scoped_to(:medium_id) }
  end

  context "instance" do
    pending "#alpha_parts"

    describe "#display_name" do
      pending "basic"
      pending "full"
    end
  end
end
