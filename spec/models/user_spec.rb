# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_atomically_validatable_model", { first_name: nil, last_name: nil } do
      subject { create(:minimal_user) }
    end
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "Member",
          "Writer",
          "Editor",
          "Admin",
          "Super Admin",
        ])
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:all) }
    end
  end

  context "scope-related" do
    let!(  :jenny) { create(:writer,      first_name: "Jenny",   last_name: "Foster",  username: "jenny"  ) }
    let!(:charlie) { create(:member,      first_name: "Charlie", last_name: "Smith",   username: "charlie") }
    let!(  :brian) { create(:super_admin, first_name: "Brian",   last_name: "Dillard", username: "brian"  ) }
    let!( :gruber) { create(:editor,      first_name: "John",    last_name: "Gruber",  username: "gruber" ) }

    before(:each) do
      create(:minimal_post, :published, author: jenny )
      create(:minimal_post, :published, author: brian )
      create(:minimal_post, :draft,     author: gruber)
    end

    describe "self#published" do
      it "includes published writers, unsorted" do
        expect(described_class.published).to eq([jenny, brian])
      end

      describe "self#published_author!" do
        it "finds only published writers by username" do
          expect(described_class.published_author!("jenny")).to eq(jenny)
          expect(described_class.published_author!("brian")).to eq(brian)
        end

        it "raises if not published" do
          expect {
            described_class.published_author!("gruber")
          }.to raise_exception(ActiveRecord::RecordNotFound)
        end

        it "raises if not found" do
          expect {
            described_class.published_author!("oops")
          }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "self#eager" do
      describe "is eager" do
        subject { described_class.eager.where(id: brian.id).take }

        specify { expect(subject.association(:posts   )).to be_loaded }
        specify { expect(subject.association(:works   )).to be_loaded }
        specify { expect(subject.association(:creators)).to be_loaded }
      end
    end

    describe "self#for_admin" do
      it "includes everyone, unsorted" do
        expect(described_class.for_admin).to eq([jenny, charlie, brian, gruber])
      end

      describe "is eager" do
        subject { described_class.for_admin.where(id: brian.id).take }

        specify { expect(subject.association(:posts   )).to be_loaded }
        specify { expect(subject.association(:works   )).to be_loaded }
        specify { expect(subject.association(:creators)).to be_loaded }
      end
    end

    describe "self#for_site" do
      it "includes published writers, alphabetized" do
        expect(described_class.for_site).to eq([brian, jenny])
      end

      describe "is eager" do
        subject { described_class.for_site.where(id: brian.id).take }

        specify { expect(subject.association(:posts   )).to be_loaded }
        specify { expect(subject.association(:works   )).to be_loaded }
        specify { expect(subject.association(:creators)).to be_loaded }
      end
    end
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
    subject { create_minimal_instance }

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
    describe "can_administer?" do
      specify { expect(create(     :member).can_administer?).to eq(false) }
      specify { expect(create(     :writer).can_administer?).to eq(false) }
      specify { expect(create(     :editor).can_administer?).to eq(false) }
      specify { expect(create(      :admin).can_administer?).to eq(true ) }
      specify { expect(create(:super_admin).can_administer?).to eq(true ) }
    end

    describe "can_post?" do
      specify { expect(create(     :member).can_post?).to eq(false) }
      specify { expect(create(     :writer).can_post?).to eq(true ) }
      specify { expect(create(     :editor).can_post?).to eq(true ) }
      specify { expect(create(      :admin).can_post?).to eq(true ) }
      specify { expect(create(:super_admin).can_post?).to eq(true ) }
    end

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
