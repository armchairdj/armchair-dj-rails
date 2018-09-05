# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  alpha                  :string
#  bio                    :text
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  middle_name            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("member"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_alpha                 (alpha)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#


require "rails_helper"

RSpec.describe User do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:links, :posts, :playlists, :works, :makers] }
    end

    it_behaves_like "a_linkable_model"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "for public site" do
      let(:saru   ) { create(:member, first_name: "Saru",    last_name: "Ramanan", username: "saru"   ) }
      let(:monique) { create(:writer, first_name: "Monique", last_name: "Hyman",   username: "monique") }
      let(:celia  ) { create(:editor, first_name: "Celia",   last_name: "Esdale",  username: "celia"  ) }
      let(:charlie) { create(:admin,  first_name: "Charlie", last_name: "Smith",   username: "charlie") }
      let(:brian  ) { create(:root,   first_name: "Brian",   last_name: "Dillard", username: "brian"  ) }

      let(:ids       ) { [saru, monique, celia, charlie, brian].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      before(:each) do
        create(:minimal_article, :draft,     author: monique)
        create(:minimal_article, :scheduled, author: celia  )
        create(:minimal_article, :published, author: charlie)
        create(:minimal_article, :published, author: brian  )
      end

      describe "self#for_public" do
        subject { collection.for_public }

        it "includes only published writers" do
          is_expected.to contain_exactly(charlie, brian)
        end
      end

      describe "#published?" do
        specify { expect(   saru.published?).to eq(false) }
        specify { expect(monique.published?).to eq(false) }
        specify { expect(  celia.published?).to eq(false) }
        specify { expect(charlie.published?).to eq(true ) }
        specify { expect(  brian.published?).to eq(true ) }
      end
    end

    describe "self#for_cms_user" do
      let(:no_user) { nil }
      let(:member) { create(:member) }
      let(:writer) { create(:writer) }
      let(:editor) { create(:editor) }
      let(:admin_1) { create(:admin ) }
      let(:admin_2) { create(:admin ) }
      let(:root_1) { create(:root  ) }
      let(:root_2) { create(:root  ) }

      let!(:ids) { [member, writer, editor, admin_1, admin_2, root_1, root_2].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

      subject { collection.for_cms_user(instance) }

      context "when passed a nil user" do
        let(:instance) { no_user }

        it "prevents access to all users" do
          is_expected.to eq(described_class.none)
        end
      end

      context "when passed a member" do
        let(:instance) { member }

        it "prevents access to all users" do
          is_expected.to eq(described_class.none)
        end
      end

      context "when passed a writer" do
        let(:instance) { writer }

        it "prevents access to all users" do
          is_expected.to eq(described_class.none)
        end
      end

      context "when passed an editor" do
        let(:instance) { editor }

        it "prevents access to all users" do
          is_expected.to eq(described_class.none)
        end
      end

      context "when passed an admin" do
        let(:instance) { admin_1 }
        let(:expected) { [member, writer, editor, admin_2] }

        it "allows access to all users except the passed user and root users" do
          is_expected.to contain_exactly(*expected)
        end
      end

      context "when passed a root" do
        let(:instance) { root_1 }
        let(:expected) { [member, writer, editor, admin_1, admin_2, root_1, root_2] }

        it "allows access to all users including the passed user" do
          is_expected.to contain_exactly(*expected)
        end
      end
    end
  end

  describe "associations" do
   it { is_expected.to have_many(:posts    ).dependent(:nullify) }
   it { is_expected.to have_many(:articles ).dependent(:nullify) }
   it { is_expected.to have_many(:reviews  ).dependent(:nullify) }
   it { is_expected.to have_many(:mixtapes ).dependent(:nullify) }
   it { is_expected.to have_many(:playlists).dependent(:nullify) }

   it { is_expected.to have_many(:works).through(:reviews) }

   it { is_expected.to have_many(:makers).through(:works) }
  end

  describe "attributes" do
    describe "enums" do
      describe "role" do
        it_behaves_like "a_model_with_a_better_enum_for", :role
      end
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name ) }

    it { is_expected.to validate_presence_of(:role) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    describe "enforce username format" do
      it { is_expected.to     allow_value("ArmchairDJ10039" ).for(:username) }
      it { is_expected.to_not allow_value("Armchair-DJ10039").for(:username) }
      it { is_expected.to_not allow_value("Armchair_DJ10039").for(:username) }
      it { is_expected.to_not allow_value("Armchair/DJ10039").for(:username) }
      it { is_expected.to_not allow_value("Armchair%DJ10039").for(:username) }
      it { is_expected.to_not allow_value("Armchair.DJ10039").for(:username) }
    end

    describe "conditional" do
      describe "as member" do
        subject { create(:member) }

        it { is_expected.to validate_absence_of(:bio) }
      end

      describe "as writer" do
        subject { create(:writer) }

        it { is_expected.to_not validate_absence_of(:bio) }
      end

      describe "as editor" do
        subject { create(:editor) }

        it { is_expected.to_not validate_absence_of(:bio) }
      end

      describe "as admin" do
        subject { create(:admin) }

        it { is_expected.to_not validate_absence_of(:bio) }
      end

      context "as root" do
        subject { create(:root) }

        it { is_expected.to_not  validate_absence_of(:bio) }
      end
    end
  end

  describe "hooks" do
    describe "after_initialize" do
      let(:instance) { build_minimal_instance }

      subject { instance.role }

      it "database sets the default role to member" do
        is_expected.to eq("member")
      end
    end
  end

  describe "instance" do
    let(:instance) { build_minimal_instance }

    describe "role" do
      let(:member) { create(:member) }
      let(:writer) { create(:writer) }
      let(:editor) { create(:editor) }
      let(:admin) { create( :admin) }
      let(:root) { create(  :root) }

      describe "booleans" do
        describe "#can_write? is true for writers, editors, admins & roots" do
          specify { expect(member.can_write?).to eq(false) }
          specify { expect(writer.can_write?).to eq(true ) }
          specify { expect(editor.can_write?).to eq(true ) }
          specify { expect( admin.can_write?).to eq(true ) }
          specify { expect(  root.can_write?).to eq(true ) }
        end

        describe "#can_edit? is true for editors, admins & roots" do
          specify { expect(member.can_edit?).to eq(false) }
          specify { expect(writer.can_edit?).to eq(false) }
          specify { expect(editor.can_edit?).to eq(true ) }
          specify { expect( admin.can_edit?).to eq(true ) }
          specify { expect(  root.can_edit?).to eq(true ) }
        end

        describe "#can_publish? is true for admins & roots" do
          specify { expect(member.can_publish?).to eq(false) }
          specify { expect(writer.can_publish?).to eq(false) }
          specify { expect(editor.can_publish?).to eq(false) }
          specify { expect( admin.can_publish?).to eq(true ) }
          specify { expect(  root.can_publish?).to eq(true ) }
        end

        describe "#can_destroy? is true for roots" do
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

          it "is empty for members" do
            expect(member.assignable_role_options).to eq([])
          end

          it "is empty for writers" do
            expect(writer.assignable_role_options).to eq([])
          end

          it "is empty for editors" do
            expect(editor.assignable_role_options).to eq([])
          end

          it "includes everything but root for admins" do
            expect(admin.assignable_role_options).to eq(options[0..3])
          end

          it "includes everything for roots" do
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

      describe "without middle name" do
        let(:instance) { create(:minimal_user, first_name: "Derrick", last_name: "May") }

        it { is_expected.to eq("Derrick May") }
      end

      context "with middle name" do
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
