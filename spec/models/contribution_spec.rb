# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contribution, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:ROLE_GROUPINGS) }
  end

  context "concerns" do
    it_behaves_like "an_application_record"

    # it_behaves_like "an_atomically_validatable_model", { work: nil, creator: nil } do
    #   subject { create(:minimal_contribution) }
    # end
  end

  context "class" do
    pending "self#grouped_role_options"
  end

  context "scopes" do
    pending "primary"
    pending "secondary"
    pending "for_admin"
    pending "for_site"
    pending "viewable"
    pending "alphabetical"
  end

  context "associations" do
    it { should belong_to(:creator) }
    it { should belong_to(:work   ) }
  end

  context "attributes" do
    context "nested" do
      it { should accept_nested_attributes_for(:creator) }

      describe "reject_if" do
        it "rejects with blank creator name" do
          instance = build(:contribution_with_new_creator, creator_attributes: {
            "0" => { "name" => "" }
          })

          expect { instance.save }.to_not change { Contribution.count }

          expect(instance).to have_errors(creator: :blank)
        end
      end
    end

    context "enums" do
      describe "role" do
        it { should define_enum_for(:role) }

        it_behaves_like "an_enumable_model", [:role]
      end
    end
  end

  context "validations" do
    it { should validate_presence_of(:role   ) }
    it { should validate_presence_of(:work   ) }
    it { should validate_presence_of(:creator) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role) }
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    describe "private" do
      # Nothing so far.
    end
  end
end
