require "rails_helper"

RSpec.describe Credit, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_contributable_model"
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id) }
  end

  context "instance" do
    describe "#alpha_parts" do
      subject { create_minimal_instance }

      it "uses work and creator" do
        expect(subject.alpha_parts).to eq([
          subject.work.alpha_parts,
          subject.creator.alpha_parts
        ])
      end
    end
  end
end
