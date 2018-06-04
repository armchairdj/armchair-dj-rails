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
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.medium.alpha_parts, instance.name]) }
    end

    describe "#display_name" do
      describe "basic" do
        subject { instance.display_name }

        it { is_expected.to eq(instance.name) }
      end

      describe "full" do
        subject { instance.display_name(full: true) }

        it { is_expected.to eq("#{instance.medium.name}: #{instance.name}") }
      end
    end
  end
end
