# frozen_string_literal: true

RSpec.shared_examples "a_contributable_model" do
  describe "included" do
    describe "scope-related" do
      let!(:with_published) { create_minimal_instance }
      let!(:with_scheduled) { create_minimal_instance }
      let!(:with_draft    ) { create_minimal_instance }
      let!(:with_none     ) { create_minimal_instance }

      let(:ids) { [with_published, with_scheduled, with_draft, with_none].map(&:id) }

      before(:each) do
        create(:minimal_review, :published, work: with_published.work)
        create(:minimal_review, :scheduled, work: with_scheduled.work)
        create(:minimal_review, :draft,     work:     with_draft.work)
      end

      describe "self#for_show" do
        subject { described_class.for_show.where(id: ids) }

        it { is_expected.to eager_load(:work, :creator) }
      end

      describe "self#for_list" do
        subject { described_class.for_admin.where(id: ids) }

        it { is_expected.to     contain_exactly(with_published, with_scheduled, with_draft, with_none) }

        it { is_expected.to_not eager_load(:work, :creator) }
      end
    end

    describe "associations" do
      it { is_expected.to belong_to(:creator) }
      it { is_expected.to belong_to(:work   ) }
    end

    describe "validations" do
      subject { create_minimal_instance }

      it { is_expected.to validate_presence_of(:creator) }
      it { is_expected.to validate_presence_of(:work   ) }
    end
  end

  describe "instance" do
    # Nothing so far.
  end
end
