# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_atomically_validatable_model", { first_name: nil, last_name: nil } do
      subject { create(:minimal_user) }
    end
  end

  context "class" do
    pending "self#find_by_username!"

    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "Member",
          "Contributor",
          "Admin",
        ])
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:all) }
    end
  end

  context "scopes" do
    describe "alphabetical" do
      let!(:michelle_dillardo) { create(:minimal_user, first_name: "Michelle",                    last_name: "Dillardo") }
      let!(  :brian_j_dillard) { create(:minimal_user, first_name: "Brian",    middle_name: "J.", last_name: "Dillard" ) }
      let!(    :brian_dillard) { create(:minimal_user, first_name: "Brian",                       last_name: "Dillard" ) }
      let!( :michelle_dillard) { create(:minimal_user, first_name: "Michelle",                    last_name: "Dillard" ) }

      specify { expect(described_class.alphabetical.to_a).to eq([
        brian_j_dillard, brian_dillard, michelle_dillard, michelle_dillardo
      ]) }
    end

    pending "eager"

    pending "for_admin"

    pending "for_site"
  end

  context "associations" do
   it { should have_many(:posts) }

   it { should have_many(:works).through(:posts) }

   it { should have_many(:creators).through(:works) }
  end

  context "attributes" do
    context "nested" do
      # Nothing so far.
    end

    context "enums" do
      describe "role" do
        it { should define_enum_for(:role) }

        it_behaves_like "an_enumable_model", [:role]
      end
    end
  end

  context "validations" do
    subject { create(:minimal_user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name ) }

    it { should validate_presence_of(:role) }

    it { should validate_presence_of(  :username) }
    it { should validate_uniqueness_of(:username) }

    context "conditional" do
      context "as member" do
        subject { create(:member) }

        it { should validate_absence_of(:bio) }
      end

      context "as writer" do
        subject { create(:writer) }

        it { should_not validate_absence_of(:bio) }
      end

      context "as editor" do
        subject { create(:editor) }

        it { should_not validate_absence_of(:bio) }
      end

      context "as admin" do
        subject { create(:admin) }

        it { should_not validate_absence_of(:bio) }
      end

      context "as super_admin" do
        subject { create(:super_admin) }

        it { should_not validate_absence_of(:bio) }
      end
    end
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    pending "can_post?"

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
      # Nothing so far.
    end
  end
end
