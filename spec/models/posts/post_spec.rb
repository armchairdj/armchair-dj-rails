# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post do
  subject(:instance) { create_minimal_instance }

  describe "ApplicationRecord" do
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

  describe ":AuthorAssociation" do
    it_behaves_like "an_authorable_model"

    describe ".for_cms_user" do
      subject(:association) { collection.for_cms_user(instance) }

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

  describe ":ContentAttributes" do
    it { is_expected.to validate_length_of(:summary).is_at_least(40).is_at_most(320) }

    it { is_expected.to allow_value("", nil).for(:summary) }

    describe "conditional validation" do
      context "when draft" do
        subject(:instance) { build_minimal_instance(:draft) }

        it { is_expected.to_not validate_presence_of(:body) }
      end

      context "when scheduled" do
        subject(:instance) { create_minimal_instance(:scheduled) }

        it { is_expected.to validate_presence_of(:body) }
      end

      context "when published" do
        subject(:instance) { create_minimal_instance(:published) }

        it { is_expected.to validate_presence_of(:body) }
      end
    end

    describe "#formatted_body" do
      subject(:formatted_body) { instance.formatted_body }

      let(:renderer) { double }

      before do
        allow(instance).to receive(:renderer).and_return(renderer)
        allow(renderer).to receive(:render).and_return("rendered markdown")
      end

      context "when on happy path" do
        let(:instance) { build_minimal_instance(body: "markdown") }

        it { is_expected.to eq("rendered markdown".html_safe) }
      end

      context "with nil body" do
        let(:instance) { build_minimal_instance(body: nil) }

        it { is_expected.to eq(nil) }
      end
    end
  end

  describe ":LinksAssociation" do
    it_behaves_like "a_linkable_model"
  end

  describe ":PublicSite" do
    let(:draft) { create_minimal_instance(:draft) }
    let(:scheduled) { create_minimal_instance(:scheduled) }
    let(:published) { create_minimal_instance(:published) }
    let(:scope) { described_class.where(id: [draft, scheduled, published].map(&:id)) }

    specify ".reverse_cron orders descending by published_at, publish_on, updated_at" do
      expect(scope.reverse_cron).to eq([draft, scheduled, published])
    end

    specify ".for_public includes only published posts and sorts reverse_cron" do
      expect(described_class).to receive(:reverse_cron).and_call_original

      expect(scope.for_public).to eq([published])
    end

    pending ".additional_posts"
    pending "#related_posts"
  end

  describe ":StiInheritance" do
    it { is_expected.to validate_presence_of(:type) }
  end

  describe ":TagsAssociation" do
    it { is_expected.to have_and_belong_to_many(:tags) }

    describe ".by_tag" do
      let(:tags) { create_list(:minimal_tag, 4) }

      let!(:posts) do
        [
          create_minimal_instance(tag_ids: [tags[0].id]),
          create_minimal_instance(tag_ids: [tags[1].id]),
          create_minimal_instance(tag_ids: [tags[2].id]),
          create_minimal_instance
        ]
      end

      it "finds posts by single tag" do
        expect(described_class.by_tag(tags[0])).to contain_exactly(posts[0])
      end

      it "finds posts by multiple tags" do
        expect(described_class.by_tag(tags[1..2])).to contain_exactly(*posts[1..2])
      end

      it "returns an empty relation if nothing found" do
        expect(described_class.by_tag(tags[3])).to be_empty
      end

      it "returns an empty relation if tags are nil" do
        expect(described_class.by_tag(nil)).to be_empty
      end
    end
  end

  describe ":StatusAttribute" do
    it "cannot be directly assigned" do
      instance = described_class.new

      expect { instance.status = :draft }.to raise_exception(AASM::NoDirectAssignmentError)
    end

    it_behaves_like "a_model_with_a_better_enum_for", :status

    describe "scopes and booleans" do
      let(:draft) { create_minimal_instance(:draft) }
      let(:scheduled) { create_minimal_instance(:scheduled) }
      let(:published) { create_minimal_instance(:published) }

      let(:ids) { [draft, scheduled, published].map(&:id) }
      let(:scope) { described_class.where(id: ids) }

      specify ".draft contains only draft posts" do
        expect(scope.draft).to contain_exactly(draft)
      end

      specify ".scheduled contains only scheduled posts" do
        expect(scope.scheduled).to contain_exactly(scheduled)
      end

      specify ".published contains only published posts" do
        expect(scope.published).to contain_exactly(published)
      end

      specify ".unpublished contains only draft and scheduled posts" do
        expect(scope.unpublished).to contain_exactly(draft, scheduled)
      end

      specify "#draft? is true only for draft posts" do
        expect(draft.draft?).to eq(true)
        expect(scheduled.draft?).to eq(false)
        expect(published.draft?).to eq(false)
      end

      specify "#scheduled? is true only for scheduled posts" do
        expect(draft.scheduled?).to eq(false)
        expect(scheduled.scheduled?).to eq(true)
        expect(published.scheduled?).to eq(false)
      end

      specify "#published? is true only for published posts" do
        expect(draft.published?).to eq(false)
        expect(scheduled.published?).to eq(false)
        expect(published.published?).to eq(true)
      end

      specify "#unpublished? is true only for draft and scheduled posts" do
        expect(draft.unpublished?).to eq(true)
        expect(scheduled.unpublished?).to eq(true)
        expect(published.unpublished?).to eq(false)
      end
    end
  end

  describe ":StateMachine" do
    let(:draft) { create_minimal_instance(:draft) }
    let(:scheduled) { create_minimal_instance(:scheduled) }
    let(:published) { create_minimal_instance(:published) }

    specify "new instance has draft state" do
      expect(described_class.new).to have_state(:draft)
      expect(draft).to have_state(:draft)
    end

    specify "scheduled instance has scheduled state" do
      expect(scheduled).to have_state(:scheduled)
    end

    specify "published instance has published state" do
      expect(published).to have_state(:published)
    end

    specify "draft posts with publish_on can be scheduled" do
      draft.publish_on = 3.weeks.from_now

      expect(draft.schedule!).to eq(true)
    end

    specify "unscheduling a scheduled post clears publish_on" do
      expect(scheduled.unschedule!).to eq(true)
      expect(scheduled.publish_on).to eq(nil)
    end

    specify "publishing a draft post sets published_at" do
      expect(draft.publish!).to eq(true)
      expect(draft.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
    end

    specify "publishing a scheduled post sets published_at and clears publish_on" do
      expect(scheduled.publish!).to eq(true)
      expect(scheduled.publish_on).to eq(nil)
      expect(scheduled.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
    end

    specify "unpublishing a published post clears published_at" do
      expect(published.unpublish!).to eq(true)
      expect(published.published_at).to eq(nil)
    end

    specify "may_schedule? is true only for draft posts" do
      expect(draft.may_schedule?).to eq(true)

      expect(scheduled.may_schedule?).to eq(false)
      expect(published.may_schedule?).to eq(false)
    end

    specify "may_unschedule? is true only for scheduled posts" do
      expect(scheduled.may_unschedule?).to eq(true)

      expect(draft.may_unschedule?).to eq(false)
      expect(published.may_unschedule?).to eq(false)
    end

    specify "may_publish? is true only for draft and scheduled posts" do
      expect(draft.may_publish?).to eq(true)
      expect(scheduled.may_publish?).to eq(true)

      expect(published.may_publish?).to eq(false)
    end

    specify "may_unpublish? is true only for published posts" do
      expect(published.may_unpublish?).to eq(true)

      expect(draft.may_unpublish?).to eq(false)
      expect(scheduled.may_unpublish?).to eq(false)
    end

    specify "only scheduled and published posts can transition to draft" do
      expect(draft).to_not allow_transition_to(:draft)

      expect(scheduled).to allow_transition_to(:draft)
      expect(published).to allow_transition_to(:draft)
    end

    specify "only draft posts can transition to scheduled" do
      expect(draft).to allow_transition_to(:scheduled)

      expect(scheduled).to_not allow_transition_to(:scheduled)
      expect(published).to_not allow_transition_to(:scheduled)
    end

    specify "only draft and scheduled posts can transition to published" do
      expect(draft).to allow_transition_to(:published)
      expect(scheduled).to allow_transition_to(:published)

      expect(published).to_not allow_transition_to(:published)
    end
  end

  describe ":StateMachineValidation" do
    context "when draft" do
      subject(:instance) { build_minimal_instance(:draft) }

      it { is_expected.to validate_absence_of(:publish_on) }
      it { is_expected.to validate_absence_of(:published_at) }
    end

    context "when scheduled" do
      subject(:instance) { create_minimal_instance(:scheduled) }

      it { is_expected.to validate_presence_of(:publish_on) }
      it { is_expected.to validate_absence_of(:published_at) }

      it "validates that publish_on is in the future" do
        instance.publish_on = Date.today - 1
        instance.valid?

        is_expected.to have_error(:publish_on, :after)
      end
    end

    context "when published" do
      subject(:instance) { create_minimal_instance(:published) }

      it { is_expected.to validate_absence_of(:publish_on) }
      it { is_expected.to validate_presence_of(:published_at) }
    end
  end

  describe ":StateMachineTransitions" do
    pending "virtual attributes trigger correct transitions"

    describe "scheduling" do
      let!(:future) { create_minimal_instance(:scheduled, publish_on: 4.days.from_now) }
      let!(:current) { create_minimal_instance(:scheduled, publish_on: 2.days.from_now) }
      let!(:past_due) { create_minimal_instance(:scheduled, publish_on: 1.days.from_now) }

      describe ".scheduled_and_due" do
        it "includes only scheduled posts that have come due, ordered by schedule date" do
          Timecop.freeze(Date.today + 3) do
            expect(described_class.scheduled_and_due).to eq([
              past_due,
              current
            ])
          end
        end
      end

      describe ".publish_scheduled" do
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

  describe ":StateMachineTransitionFailures" do
    pending "#handle_failed_transition"
  end
end
