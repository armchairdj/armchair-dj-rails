# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post do
  subject { create_minimal_instance }

  describe "concerns" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      # Must specify individual fields for STI models.
      it { is_expected.to nilify_blanks_for(:alpha,   before: :validation) }
      it { is_expected.to nilify_blanks_for(:body,    before: :validation) }
      it { is_expected.to nilify_blanks_for(:slug,    before: :validation) }
      it { is_expected.to nilify_blanks_for(:summary, before: :validation) }
      it { is_expected.to nilify_blanks_for(:title,   before: :validation) }
      it { is_expected.to nilify_blanks_for(:type,    before: :validation) }
    end
  end

  describe "status" do
    describe "default value" do
      let(:instance) { described_class.new }

      subject { instance.status }

      it { is_expected.to eq("draft") }
    end

    describe "triggers conditional validation" do
      describe "on draft" do
        subject { build_minimal_instance(:draft) }

        it { is_expected.to_not validate_presence_of(:body) }
        it { is_expected.to     validate_absence_of(:publish_on) }
        it { is_expected.to     validate_absence_of(:published_at) }
      end

      describe "on scheduled" do
        subject { create_minimal_instance(:scheduled) }

        it { is_expected.to validate_presence_of(:body) }
        it { is_expected.to validate_presence_of(:publish_on) }
        it { is_expected.to validate_absence_of(:published_at) }

        describe "when publish_on is in the past" do
          before(:each) do
            subject.publish_on = Date.today - 1
            subject.valid?
          end

          it { is_expected.to have_error(:publish_on, :after) }
        end
      end

      describe "on published" do
        subject { create_minimal_instance(:published) }

        it { is_expected.to validate_presence_of(:body) }
        it { is_expected.to validate_absence_of(:publish_on) }
        it { is_expected.to validate_presence_of(:published_at) }
      end
    end

    describe "scope-related" do
      describe "for sorting and status" do
        let(:draft) { create_minimal_instance(:draft) }
        let(:scheduled) { create_minimal_instance(:scheduled) }
        let(:published) { create_minimal_instance(:published) }

        let(:ids) { [draft, scheduled, published].map(&:id) }
        let(:collection) { described_class.where(id: ids) }

        describe "self#reverse_cron" do
          subject { collection.reverse_cron }

          it "includes all, ordered descending by published_at, published_on, updated_at" do
            is_expected.to eq([draft, scheduled, published])
          end
        end

        describe "for status" do
          describe "self#draft" do
            subject { collection.draft }

            it { is_expected.to contain_exactly(draft) }
          end

          describe "self#scheduled" do
            subject { collection.scheduled }

            it { is_expected.to contain_exactly(scheduled) }
          end

          describe "self#published" do
            subject { collection.published }

            it { is_expected.to contain_exactly(published) }
          end

          describe "self#unpublished" do
            subject { collection.unpublished }

            it { is_expected.to contain_exactly(draft, scheduled) }
          end

          describe "booleans" do
            describe "#draft?" do
              specify { expect(draft.draft?).to eq(true) }
              specify { expect(scheduled.draft?).to eq(false) }
              specify { expect(published.draft?).to eq(false) }
            end

            describe "#scheduled?" do
              specify { expect(draft.scheduled?).to eq(false) }
              specify { expect(scheduled.scheduled?).to eq(true) }
              specify { expect(published.scheduled?).to eq(false) }
            end

            describe "#published?" do
              specify { expect(draft.published?).to eq(false) }
              specify { expect(scheduled.published?).to eq(false) }
              specify { expect(published.published?).to eq(true) }
            end

            describe "#unpublished?" do
              specify { expect(draft.unpublished?).to eq(true) }
              specify { expect(scheduled.unpublished?).to eq(true) }
              specify { expect(published.unpublished?).to eq(false) }
            end
          end
        end
      end
    end
  end

  describe "author" do
    it_behaves_like "an_authorable_model"
  end

  describe "body" do
    describe "#formatted_body" do
      subject { instance.formatted_body }

      let(:renderer) { double }

      before(:each) do
        allow(instance).to receive(:renderer).and_return(renderer)
        allow(renderer).to receive(:render).and_return("rendered markdown")
      end

      context "happy path" do
        let(:instance) { build_minimal_instance(body: "markdown") }

        it { is_expected.to eq("rendered markdown".html_safe) }
      end

      context "nil body" do
        let(:instance) { build_minimal_instance(body: nil) }

        it { is_expected.to eq(nil) }
      end
    end
  end

  describe "summary" do
    it { is_expected.to validate_length_of(:summary).is_at_least(40).is_at_most(320) }

    it { is_expected.to allow_value("", nil).for(:summary) }
  end

  describe "tags" do
    it { is_expected.to have_and_belong_to_many(:tags) }
  end

  describe "links" do
    it_behaves_like "a_linkable_model"
  end

  describe "state machine" do
    let(:virgin) { described_class.new }
    let(:draft) { create_minimal_instance(:draft) }
    let(:scheduled) { create_minimal_instance(:scheduled) }
    let(:published) { create_minimal_instance(:published) }

    describe "states" do
      specify { expect(virgin).to have_state(:draft) }
      specify { expect(draft).to have_state(:draft) }
      specify { expect(scheduled).to have_state(:scheduled) }
      specify { expect(published).to have_state(:published) }
    end

    describe "events" do
      describe "schedule" do
        specify do
          draft.publish_on = 3.weeks.from_now

          expect(draft.schedule!).to eq(true)
        end
      end

      describe "unschedule" do
        specify do
          expect(scheduled.unschedule!).to eq(true)
          expect(scheduled.publish_on).to eq(nil)
        end
      end

      describe "publish" do
        context "draft" do
          specify do
            expect(draft.publish!).to eq(true)
            expect(draft.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
          end
        end

        context "scheduled" do
          specify do
            expect(scheduled.publish!).to eq(true)
            expect(scheduled.publish_on).to eq(nil)
            expect(scheduled.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
          end
        end
      end

      describe "unpublish" do
        specify do
          expect(published.unpublish!).to eq(true)
          expect(published.published_at).to eq(nil)
        end
      end
    end

    describe "booleans" do
      describe "may_schedule?" do
        specify "on draft" do
          expect(draft.may_schedule?).to eq(true)
        end

        specify "on scheduled" do
          expect(scheduled.may_schedule?).to eq(false)
        end

        specify "on published" do
          expect(published.may_schedule?).to eq(false)
        end
      end

      describe "may_unschedule?" do
        specify "on draft" do
          expect(draft.may_unschedule?).to eq(false)
        end

        specify "on scheduled" do
          expect(scheduled.may_unschedule?).to eq(true)
        end

        specify "on published" do
          expect(published.may_unschedule?).to eq(false)
        end
      end

      describe "may_publish?" do
        specify "on draft" do
          expect(draft.may_publish?).to eq(true)
        end

        specify "on scheduled" do
          expect(scheduled.may_publish?).to eq(true)
        end

        specify "on published" do
          expect(published.may_publish?).to eq(false)
        end
      end

      describe "may_unpublish?" do
        specify "on draft" do
          expect(draft.may_unpublish?).to eq(false)
        end

        specify "on scheduled" do
          expect(scheduled.may_unpublish?).to eq(false)
        end

        specify "on published" do
          expect(published.may_unpublish?).to eq(true)
        end
      end
    end

    describe "transitions" do
      describe "to draft" do
        specify { expect(draft).to_not allow_transition_to(:draft) }
        specify { expect(scheduled).to     allow_transition_to(:draft) }
        specify { expect(published).to     allow_transition_to(:draft) }
      end

      describe "to scheduled" do
        specify { expect(draft).to allow_transition_to(:scheduled) }
        specify { expect(scheduled).to_not allow_transition_to(:scheduled) }
        specify { expect(published).to_not allow_transition_to(:scheduled) }
      end

      describe "to published" do
        specify { expect(draft).to allow_transition_to(:published) }
        specify { expect(scheduled).to     allow_transition_to(:published) }
        specify { expect(published).to_not allow_transition_to(:published) }
      end
    end

    pending "virtual attributes trigger correct transitions"
  end

  describe "public vs. admin" do
    describe "self#for_public" do
      let(:draft) { create_minimal_instance(:draft) }
      let(:scheduled) { create_minimal_instance(:scheduled) }
      let(:published) { create_minimal_instance(:published) }

      let!(:ids) { [draft, scheduled, published].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

      subject { collection.for_public }

      it { is_expected.to eq [published] }
    end

    describe "self#for_cms_user" do
      let!(:no_user) { nil }
      let!(:member) { create(:member) }
      let!(:writer) { create(:writer) }
      let!(:editor) { create(:editor) }
      let!(:admin) { create(:admin) }
      let!(:root) { create(:root) }

      let(:writer_post) { create(:minimal_post, author: writer) }
      let(:editor_post) { create(:minimal_post, author: editor) }
      let(:admin_post) { create(:minimal_post, author: admin) }
      let(:root_post) { create(:minimal_post, author: root) }

      let!(:ids) { [writer_post, editor_post, admin_post, root_post].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

      subject { collection.for_cms_user(instance) }

      context "with nil user" do
        let(:instance) { no_user }

        it "includes nothing" do
          is_expected.to eq(described_class.none)
        end
      end

      context "with member" do
        let(:instance) { member }

        it "includes nothing" do
          is_expected.to eq(described_class.none)
        end
      end

      context "with writer" do
        let(:instance) { writer }

        it "includes only own posts" do
          is_expected.to contain_exactly(writer_post)
        end
      end

      context "with editor" do
        let(:instance) { editor }

        it "includes everything" do
          is_expected.to match_array(collection.all)
        end
      end

      context "with admin" do
        let(:instance) { admin }

        it "includes everything" do
          is_expected.to match_array(collection.all)
        end
      end

      context "with root" do
        let(:instance) { root }

        it "includes everything" do
          is_expected.to match_array(collection.all)
        end
      end
    end
  end

  describe "scheduling" do
    let!(:future) { create_minimal_instance(:scheduled, publish_on: 4.days.from_now) }
    let!(:current) { create_minimal_instance(:scheduled, publish_on: 2.days.from_now) }
    let!(:past_due) { create_minimal_instance(:scheduled, publish_on: 1.days.from_now) }

    describe "self#scheduled_and_due" do
      it "includes only scheduled that have come due, ordered by schedule date" do
        Timecop.freeze(Date.today + 3) do
          expect(described_class.scheduled_and_due).to eq([
            past_due,
            current
          ])
        end
      end
    end

    describe "self#publish_scheduled" do
      it "publishes scheduled if publish_on is past" do
        Timecop.freeze(Date.today + 3) do
          expect(described_class.publish_scheduled).to eq(
            all:     [past_due, current],
            success: [past_due, current],
            failure: []
          )

          expect(past_due.reload).to be_published
          expect(current.reload).to be_published
        end
      end

      it "unschedules on failed publish" do
        Timecop.freeze(Date.today + 3) do
          current.update_column(:body, nil)

          expect(described_class.publish_scheduled).to eq(
            all:     [past_due, current],
            success: [past_due],
            failure: [current]
          )

          expect(past_due.reload).to be_published
          expect(current.reload).to be_draft
        end
      end

      it "does not pubish if publish_on is future" do
        Timecop.freeze(Date.today + 3) do
          described_class.publish_scheduled

          expect(future.reload).to be_scheduled
        end
      end
    end
  end
end
