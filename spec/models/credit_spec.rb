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

    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:work, :creator] }
    end

    it_behaves_like "a_listable_model", :work do
      let(:primary) { create(:minimal_work, maker_count: 5).credits.sorted }
      let(  :other) { create(:minimal_work, maker_count: 5).credits.sorted }
    end

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id) }
  end
end
