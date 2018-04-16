require "rails_helper"

RSpec.describe User, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "associations" do
    # Nothing so far.
  end

  context "nested_attributes" do
    # Nothing so far.
  end

  context "enums" do
    describe "role" do
      it { should define_enum_for(:role) }

      it_behaves_like "an enumable model", [:role]
    end
  end

  context "scopes" do
    pending "alphabetical"
  end

  context "validations" do
    subject { create(:minimal_user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
  end

  context "hooks" do
    # Nothing so far.
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "Member",
          "Contributor",
          "Admin",
        ])
      end

      specify "values are symbols of scopes" do
        described_class.admin_scopes.values.each do |sym|
          expect(sym).to be_a_kind_of(Symbol)

          expect(described_class.respond_to?(sym)).to eq(true)
        end
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:all) }
    end
  end

  context "instance" do
    describe "#display_name" do
      describe "no middle name" do
        subject { create(:minimal_user, first_name: "Derrick", last_name: "May") }

        specify { expect(subject.display_name).to eq("Derrick May") }
      end

      describe "with middle name" do
        subject { create(:minimal_user, first_name: "Brian", middle_name: "J.", last_name: "Dillard") }

        specify { expect(subject.display_name).to eq("Brian J. Dillard") }
      end
    end

    describe "private" do
      describe "callbacks" do
        # Nothing so far.
      end
    end
  end

  context "concerns" do
    # Nothing so far.
  end
end
