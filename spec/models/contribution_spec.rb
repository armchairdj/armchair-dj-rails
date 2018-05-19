# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contribution, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_workable_model"
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:role_id) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role_id) }
  end

  context "instance" do
    pending "#alpha_parts"
  end
end
