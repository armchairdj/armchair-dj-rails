require "rails_helper"

RSpec.describe Facet, type: :model do
  context "concerns" do
    it_behaves_like "an_application_record"
  end

  context "scope-related" do
    context "basics" do
      pending "self#sorted"
      pending "self#eager"
      pending "self#for_admin"
      pending "self#for_site"
    end
  end

  context "associations" do
    it { should belong_to(:medium) }

    it { should belong_to(:category) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:medium) }

    it { should validate_presence_of(:category) }
  end
end
