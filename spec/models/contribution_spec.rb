# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contribution, type: :model do
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
    # Nothing so far.
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:role) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role_id) }
  end

  context "instance" do
    pending "#alpha_parts"
  end
end
