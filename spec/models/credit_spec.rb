# == Schema Information
#
# Table name: credits
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint(8)
#  work_id    :bigint(8)
#
# Indexes
#
#  index_credits_on_alpha       (alpha)
#  index_credits_on_creator_id  (creator_id)
#  index_credits_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => creators.id)
#  fk_rails_...  (work_id => works.id)
#

require "rails_helper"

RSpec.describe Credit, type: :model do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "a_contributable_model"

    it_behaves_like "a_listable_model", :work do
      let(:primary) { create(:minimal_work, maker_count: 5).credits.sorted }
      let(  :other) { create(:minimal_work, maker_count: 5).credits.sorted }
    end

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      describe "nilify_blanks" do
        it { is_expected.to nilify_blanks(before: :validation) }
      end
    end
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id) }
  end

  describe "instance" do
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
