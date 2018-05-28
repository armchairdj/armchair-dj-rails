# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    let!(  :jenny) { create(:writer,  first_name: "Jenny",   last_name: "Foster",  username: "jenny"  ) }
    let!(:charlie) { create(:member,  first_name: "Charlie", last_name: "Smith",   username: "charlie") }
    let!(  :brian) { create(:root,    first_name: "Brian",   last_name: "Dillard", username: "brian"  ) }
    let!( :gruber) { create(:editor,  first_name: "John",    last_name: "Gruber",  username: "gruber" ) }

    before(:each) do
      create(:minimal_post, :published, author: jenny )
      create(:minimal_post, :published, author: brian )
      create(:minimal_post, :draft,     author: gruber)
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

    describe "self#eager" do
      subject { described_class.eager }

      it { is_expected.to eager_load(:posts, :works, :creators) }
    end

    describe "self#for_admin" do
      subject { described_class.for_admin }

      it "includes everyone, unsorted" do
        is_expected.to contain_exactly(jenny, charlie, brian, gruber)
      end

      it { is_expected.to eager_load(:posts, :works, :creators) }
    end

    describe "self#for_site" do
      subject { described_class.for_site }

      it "includes only published writers, sorted" do
        is_expected.to eq([brian, jenny])
      end

      it { is_expected.to eager_load(:posts, :works, :creators) }
    end
  end

  context "associations" do
   it { is_expected.to have_many(:posts) }

   it { is_expected.to have_many(:works).through(:posts) }

   it { is_expected.to have_many(:creators).through(:works) }
  end

  context "attributes" do
    context "enums" do
      describe "role" do
        it { is_expected.to define_enum_for(:role) }

        it_behaves_like "an_enumable_model", [:role]
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name ) }

    it { is_expected.to validate_presence_of(:role) }

    it { is_expected.to validate_presence_of(  :username) }
    it { is_expected.to validate_uniqueness_of(:username) }

    context "conditional" do
      context "as member" do
        subject { create(:member) }

        it { is_expected.to validate_absence_of(:bio) }
      end

      context "as writer" do
        subject { create(:writer) }

        it { is_expected.to_not  validate_absence_of(:bio) }
      end

      context "as editor" do
        subject { create(:editor) }

        it { is_expected.to_not  validate_absence_of(:bio) }
      end

      context "as admin" do
        subject { create(:admin) }

        it { is_expected.to_not  validate_absence_of(:bio) }
      end

      context "as root" do
        subject { create(:root) }

        it { is_expected.to_not  validate_absence_of(:bio) }
      end
    end
  end

  context "instance" do
    describe "can_write?" do
      specify { expect(create(:member).can_write?).to eq(false) }
      specify { expect(create(:writer).can_write?).to eq(true ) }
      specify { expect(create(:editor).can_write?).to eq(true ) }
      specify { expect(create( :admin).can_write?).to eq(true ) }
      specify { expect(create(  :root).can_write?).to eq(true ) }
    end

    describe "can_edit?" do
      specify { expect(create(:member).can_edit?).to eq(false) }
      specify { expect(create(:writer).can_edit?).to eq(false) }
      specify { expect(create(:editor).can_edit?).to eq(true ) }
      specify { expect(create( :admin).can_edit?).to eq(true ) }
      specify { expect(create(  :root).can_edit?).to eq(true ) }
    end

    describe "can_publish?" do
      specify { expect(create(:member).can_publish?).to eq(false) }
      specify { expect(create(:writer).can_publish?).to eq(false) }
      specify { expect(create(:editor).can_publish?).to eq(false) }
      specify { expect(create( :admin).can_publish?).to eq(true ) }
      specify { expect(create(  :root).can_publish?).to eq(true ) }
    end

    describe "can_destroy?" do
      specify { expect(create(:member).can_destroy?).to eq(false) }
      specify { expect(create(:writer).can_destroy?).to eq(false) }
      specify { expect(create(:editor).can_destroy?).to eq(false) }
      specify { expect(create( :admin).can_destroy?).to eq(false) }
      specify { expect(create(  :root).can_destroy?).to eq(true ) }
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

    describe "#alpha_parts" do
      subject { create_minimal_instance }

      it "uses full name with middle at end so that Brian Dillard and Brian J. Dillard show up consecutively" do
        expect(subject.alpha_parts).to eq([
          subject.last_name,
          subject.first_name,
          subject.middle_name
        ])
      end
    end
  end
end
