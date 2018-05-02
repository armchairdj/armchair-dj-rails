# frozen_string_literal: true

RSpec.shared_examples "a_workable_model" do
  context "included" do
    context "scope-related" do
      let!(:with_published) { create_minimal_instance }
      let!(:with_scheduled) { create_minimal_instance }
      let!(:with_draft    ) { create_minimal_instance }
      let!(:with_none     ) { create_minimal_instance }

      let(:ids) { [with_published, with_scheduled, with_draft, with_none].map(&:id) }

      before(:each) do
        create(:review, :published, work: with_published.work)
        create(:review, :scheduled, work: with_scheduled.work)
        create(:review, :draft,     work:     with_draft.work)
      end

      describe "self#eager" do
        subject { described_class.eager.where(id: ids) }

        it { should eager_load(:work, :creator) }
      end

      describe "self#viewable" do
        subject { described_class.viewable.where(id: ids) }

        it { should contain_exactly(with_published) }

        it { should eager_load(:work, :creator) }
      end

      describe "self#non_viewable" do
        subject { described_class.non_viewable.where(id: ids) }

        it { should contain_exactly(with_scheduled, with_draft, with_none) }

        it { should eager_load(:work, :creator) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        it { should contain_exactly(with_published, with_scheduled, with_draft, with_none) }

        it { should eager_load(:work, :creator) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        it { should contain_exactly(with_published) }

        it { should eager_load(:work, :creator) }

        pending "alpha"
      end
    end

    context "associations" do
      it { should belong_to(:creator) }
      it { should belong_to(:work   ) }
    end

    context "validations" do
      subject { create_minimal_instance }

      it { should validate_presence_of(:creator) }
      it { should validate_presence_of(:work   ) }
    end
  end

  context "instance" do
    describe "delegated methods" do
      subject { create_minimal_instance }

      describe "#viewable?" do
        it "delegates to work" do
           allow(subject.work).to receive(:viewable?).and_call_original
          expect(subject.work).to receive(:viewable?)

          subject.viewable?
        end
      end

      describe "#non_viewable?" do
        it "delegates to work" do
           allow(subject.work).to receive(:non_viewable?).and_call_original
          expect(subject.work).to receive(:non_viewable?)

          subject.non_viewable?
        end
      end
    end
  end
end
