require "rails_helper"

RSpec.describe Role, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    pending "self#options_for"
  end

  context "scope-related" do
    pending "self#eager"
    pending "self#for_admin"
  end

  context "associations" do
    it { is_expected.to belong_to(:medium) }

    it { is_expected.to have_many(:contributions) }

    it { is_expected.to have_many(:works).through(:contributions) }

    it { is_expected.to have_many(:posts).through(:works) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:medium) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:medium_id) }
  end

  context "instance" do
    describe "#alpha_parts" do
      subject { create_minimal_instance }

      it "uses medium and name" do
        expect(subject.alpha_parts).to eq([subject.medium.alpha_parts, subject.name])
      end
    end

    describe "#display_name" do
      pending "basic"
      pending "full"
    end
  end
end
