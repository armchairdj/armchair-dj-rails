# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contribution, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:ROLE_GROUPINGS) }
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_workable_model"

    # it_behaves_like "an_atomically_validatable_model", { work: nil, creator: nil } do
    #   subject { create(:minimal_contribution) }
    # end
  end

  context "class" do
    pending "self#grouped_role_options"
  end

  context "scope-related" do
    # Nothing so far.
  end

  context "associations" do
    # Nothing so far.
  end

  context "attributes" do
    context "enums" do
      describe "role" do
        it { should define_enum_for(:role) }

        it_behaves_like "an_enumable_model", [:role]
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:role) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role) }
  end
end
