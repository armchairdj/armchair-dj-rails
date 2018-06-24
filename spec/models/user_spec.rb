# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_linkable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    let(     :jenny) { create(:writer,  first_name: "Jenny",   last_name: "Foster",  username: "jenny"  ) }
    let(     :brian) { create(:root,    first_name: "Brian",   last_name: "Dillard", username: "brian"  ) }
    let(   :charlie) { create(:admin,   first_name: "Charlie", last_name: "Smith",   username: "charlie") }
    let(    :gruber) { create(:editor,  first_name: "John",    last_name: "Gruber",  username: "gruber" ) }
    let(       :ids) { [jenny, charlie, brian, gruber].map(&:id) }
    let(:collection) { described_class.where(id: ids) }

    before(:each) do
      create(:minimal_article, :published, author: jenny  )
      create(:minimal_article, :published, author: brian  )
      create(:minimal_article, :scheduled, author: charlie)
      create(:minimal_article, :draft,     author: gruber )
    end

    describe "self#eager" do
      subject { collection.eager }

      it { is_expected.to match_array(collection) }

      it { is_expected.to eager_load(:articles, :reviews, :mixtapes, :works, :creators) }
    end

    describe "self#for_admin" do
      subject { collection.for_admin }

      it { is_expected.to match_array(collection) }

      it { is_expected.to eager_load(:articles, :reviews, :mixtapes, :works, :creators) }
    end

    describe "self#for_site" do
      subject { collection.for_site }

      it "includes only published writers, sorted" do
        is_expected.to eq([brian, jenny])
      end

      it { is_expected.to eager_load(:articles, :reviews, :mixtapes, :works, :creators) }
    end

    describe "#published?" do
      specify { expect(  jenny.published?).to eq(true ) }
      specify { expect(  brian.published?).to eq(true ) }
      specify { expect(charlie.published?).to eq(false) }
      specify { expect( gruber.published?).to eq(false) }
    end
  end

  context "associations" do
   it { is_expected.to have_many(:articles) }
   it { is_expected.to have_many(:reviews ) }
   it { is_expected.to have_many(:mixtapes) }

   it { is_expected.to have_many(:works).through(:reviews) }

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

    pending "username format"

    context "conditional" do
      context "as member" do
        subject { create(:member) }

        it { is_expected.to validate_absence_of(:bio) }
      end

      context "as writer" do
        subject { create(:writer) }

        it { is_expected.to_not validate_absence_of(:bio) }
      end

      context "as editor" do
        subject { create(:editor) }

        it { is_expected.to_not validate_absence_of(:bio) }
      end

      context "as admin" do
        subject { create(:admin) }

        it { is_expected.to_not validate_absence_of(:bio) }
      end

      context "as root" do
        subject { create(:root) }

        it { is_expected.to_not  validate_absence_of(:bio) }
      end
    end
  end

  context "hooks" do
    context "after_initialize" do
      let(:instance) { build_minimal_instance }

      subject { instance.role }

      it { is_expected.to eq("member") }
    end
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "role" do
      let(:member) { create(:member) }
      let(:writer) { create(:writer) }
      let(:editor) { create(:editor) }
      let( :admin) { create( :admin) }
      let(  :root) { create(  :root) }

      describe "booleans" do
        describe "can_write?" do
          specify { expect(member.can_write?).to eq(false) }
          specify { expect(writer.can_write?).to eq(true ) }
          specify { expect(editor.can_write?).to eq(true ) }
          specify { expect( admin.can_write?).to eq(true ) }
          specify { expect(  root.can_write?).to eq(true ) }
        end

        describe "can_edit?" do
          specify { expect(member.can_edit?).to eq(false) }
          specify { expect(writer.can_edit?).to eq(false) }
          specify { expect(editor.can_edit?).to eq(true ) }
          specify { expect( admin.can_edit?).to eq(true ) }
          specify { expect(  root.can_edit?).to eq(true ) }
        end

        describe "can_publish?" do
          specify { expect(member.can_publish?).to eq(false) }
          specify { expect(writer.can_publish?).to eq(false) }
          specify { expect(editor.can_publish?).to eq(false) }
          specify { expect( admin.can_publish?).to eq(true ) }
          specify { expect(  root.can_publish?).to eq(true ) }
        end

        describe "can_destroy?" do
          specify { expect(member.can_destroy?).to eq(false) }
          specify { expect(writer.can_destroy?).to eq(false) }
          specify { expect(editor.can_destroy?).to eq(false) }
          specify { expect( admin.can_destroy?).to eq(false) }
          specify { expect(  root.can_destroy?).to eq(true ) }
        end
      end

      describe "methods" do
        describe "#assignable_role_options" do
          let(:options) do
            [ [ "Member", "member" ],
              [ "Writer", "writer" ],
              [ "Editor", "editor" ],
              [ "Admin",  "admin"  ],
              [ "Root",   "root"   ] ]
          end

          specify do
            expect(member.assignable_role_options).to eq([])
          end

          specify do
            expect(writer.assignable_role_options).to eq([])
          end

          specify do
            expect(editor.assignable_role_options).to eq([])
          end

          specify do
            expect(admin.assignable_role_options).to eq(options[0..3])
          end

          specify do
            expect(root.assignable_role_options).to eq(options)
          end
        end

        describe "#valid_role_assignment_for?" do
          describe "for member" do
            subject { create(:member) }

            specify do
              expect(subject.valid_role_assignment_for?(member)).to eq(false)
              expect(member).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(writer)).to eq(false)
              expect(writer).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(editor)).to eq(false)
              expect(editor).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(admin)).to eq(false)
              expect(admin).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(root)).to eq(false)
              expect(root).to have_error(:role, :invalid_assignment)
            end
          end

          describe "for writer" do
            subject { create(:writer) }

            specify do
              expect(subject.valid_role_assignment_for?(member)).to eq(false)
              expect(member).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(writer)).to eq(false)
              expect(writer).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(editor)).to eq(false)
              expect(editor).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(admin)).to eq(false)
              expect(admin).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(root)).to eq(false)
              expect(root).to have_error(:role, :invalid_assignment)
            end
          end

          describe "for editor" do
            subject { create(:editor) }

            specify do
              expect(subject.valid_role_assignment_for?(member)).to eq(false)
              expect(member).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(writer)).to eq(false)
              expect(writer).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(editor)).to eq(false)
              expect(editor).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(admin)).to eq(false)
              expect(admin).to have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(root)).to eq(false)
              expect(root).to have_error(:role, :invalid_assignment)
            end
          end

          describe "for admin" do
            subject { create(:admin) }

            specify do
              expect(subject.valid_role_assignment_for?(member)).to eq(true)
              expect(member).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(writer)).to eq(true)
              expect(writer).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(editor)).to eq(true)
              expect(editor).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(admin)).to eq(true)
              expect(admin).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(root)).to eq(false)
              expect(root).to have_error(:role, :invalid_assignment)
            end
          end

          describe "for root" do
            subject { create(:root) }

            specify do
              expect(subject.valid_role_assignment_for?(member)).to eq(true)
              expect(member).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(writer)).to eq(true)
              expect(writer).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(editor)).to eq(true)
              expect(editor).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(admin)).to eq(true)
              expect(admin).to_not have_error(:role, :invalid_assignment)
            end

            specify do
              expect(subject.valid_role_assignment_for?(root)).to eq(true)
              expect(root).to_not have_error(:role, :invalid_assignment)
            end
          end
        end
      end
    end

    describe "#display_name" do
      subject { instance.display_name }

      describe "no middle name" do
        let(:instance) { create(:minimal_user, first_name: "Derrick", last_name: "May") }

        it { is_expected.to eq("Derrick May") }
      end

      describe "with middle name" do
        let(:instance) { create(:minimal_user, first_name: "Brian", middle_name: "J", last_name: "Dillard") }

        it { is_expected.to eq("Brian J Dillard") }
      end
    end

    describe "#alpha_parts" do
      let(:instance) { create(:minimal_user, first_name: "Brian", middle_name: "J", last_name: "Dillard") }

      subject { instance.alpha_parts }

      it "uses full name with middle at end so that Brian Dillard and Brian J. Dillard show up consecutively" do
        is_expected.to eq(["Dillard", "Brian", "J"])
      end
    end
  end
end
