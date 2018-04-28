require "rails_helper"

RSpec.describe Credit, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_application_record"
    it_behaves_like "a_workable_model"

    # it_behaves_like "an_atomically_validatable_model", { work: nil, creator: nil } do
    #   subject { create(:minimal_credit) }
    # end
  end

  context "class" do
    # Nothing so far.
  end

  context "scopes" do
    # Nothing so far.
  end

  context "associations" do
    # Nothing so far.
  end

  context "attributes" do
    # Nothing so far.
  end

  context "validations" do
    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id) }
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    # Nothing so far.
  end
end
