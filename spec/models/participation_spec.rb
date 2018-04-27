# frozen_string_literal: true

require "rails_helper"

RSpec.describe Participation, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:MIRRORS) }
  end

  context "concerns" do
    # Nothing so far.
  end

  context "class" do
    # Nothing so far.
  end

  context "scopes" do
    context "for relationship" do
      let!(     :named) { create(:named  ) }
      let!(  :has_name) { create(:has_name  ) }
      let!( :member_of) { create(:member_of ) }
      let!(:has_member) { create(:has_member) }

      describe "named" do
        specify { expect(described_class.named).to include(named) }
        specify { expect(described_class.named.length).to eq(2) }
      end

      describe "has_name" do
        specify { expect(described_class.has_name).to include(has_name) }
        specify { expect(described_class.has_name.length).to eq(2) }
      end

      describe "member_of" do
        specify { expect(described_class.member_of).to include(member_of) }
        specify { expect(described_class.member_of.length).to eq(2) }
      end

      describe "has_member" do
        specify { expect(described_class.has_member).to include(has_member) }
        specify { expect(described_class.has_member.length).to eq(2) }
      end

      describe "booleans" do
        describe "named?" do
          specify { expect(  named.named?).to eq(true ) }
          specify { expect(  has_name.named?).to eq(false) }
          specify { expect( member_of.named?).to eq(false) }
          specify { expect(has_member.named?).to eq(false) }
        end

        describe "has_name?" do
          specify { expect(  named.has_name?).to eq(false) }
          specify { expect(  has_name.has_name?).to eq(true ) }
          specify { expect( member_of.has_name?).to eq(false) }
          specify { expect(has_member.has_name?).to eq(false) }
        end

        describe "member_of?" do
          specify { expect(  named.member_of?).to eq(false) }
          specify { expect(  has_name.member_of?).to eq(false) }
          specify { expect( member_of.member_of?).to eq(true ) }
          specify { expect(has_member.member_of?).to eq(false) }
        end

        describe "has_member?" do
          specify { expect(  named.has_member?).to eq(false) }
          specify { expect(  has_name.has_member?).to eq(false) }
          specify { expect( member_of.has_member?).to eq(false) }
          specify { expect(has_member.has_member?).to eq(true ) }
        end
      end
    end
  end

  context "associations" do
    it { should belong_to(:creator) }
    it { should belong_to(:participant).class_name("Creator") }
  end

  context "attributes" do
    context "nested" do
      # Nothing so far.
    end

    context "enums" do
      it { should define_enum_for(:relationship) }

      it_behaves_like "an_enumable_model", [:relationship]
    end
  end

  context "validations" do
    subject { build(:minimal_participation) }

    it { should validate_presence_of(:creator     ) }
    it { should validate_presence_of(:participant ) }
    it { should validate_presence_of(:relationship) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:relationship, :participant_id) }

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      # Nothing so far.
    end

    context "custom validators" do
      # Nothing so far.
    end
  end

  context "hooks" do
    context "after_create" do
      before(:each) do
        allow(subject).to receive(:create_mirror)
      end

      context "on create" do
        subject { build(:minimal_participation) }

        it "calls #create_mirror" do
          expect(subject).to receive(:create_mirror)

          subject.save
        end
      end

      context "on update" do
        subject { create(:minimal_participation) }

        it "does not call #create_mirror" do
          expect(subject).to_not receive(:create_mirror)

          subject.save
        end
      end
    end

    context "callbacks" do
      describe "#create_mirror" do
        context "creates mirror contribution" do
          specify "for named" do
            expect { create(:named) }.to change{ Participation.count }.by(2)

            expect(Participation.last.has_name?).to eq(true)
          end

          specify "for has_name" do
            expect { create(:has_name) }.to change{ Participation.count }.by(2)

            expect(Participation.last.named?).to eq(true)
          end

          specify "for member_of" do
            expect { create(:member_of) }.to change{ Participation.count }.by(2)

            expect(Participation.last.has_member?).to eq(true)
          end

          specify "for has_member" do
            expect { create(:has_member) }.to change{ Participation.count }.by(2)

            expect(Participation.last.member_of?).to eq(true)
          end
        end
      end
    end
  end

  context "instance" do
    describe "private" do
      # Nothing so far.
    end
  end
end
