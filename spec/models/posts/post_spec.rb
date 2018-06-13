# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post, type: :model do
  subject { create_minimal_instance }

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_authorable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"
  end

  context "class" do
    describe "self#publish_scheduled" do
      let!(:current) { create_minimal_instance(:scheduled, publish_on: 1.day.from_now) }
      let!( :future) { create_minimal_instance(:scheduled) }

      context "scope :scheduled_ready" do
        it "includes only scheduled that have come due" do
          Timecop.freeze(Date.today + 3) do
            expect(described_class.scheduled_ready).to match_array([current])
          end
        end
      end

      it "publishes scheduled if publish_on is past" do
        Timecop.freeze(Date.today + 3) do
          expect(described_class.publish_scheduled).to eq({
            total:   1,
            success: [current],
            failure: []
          })

          expect(current.reload).to be_published
        end
      end

      it "unschedules on failed publish" do
        Timecop.freeze(Date.today + 3) do
          current.update_column(:body, nil)

          expect(described_class.publish_scheduled).to eq({
            total:   1,
            success: [],
            failure: [current]
          })

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

  context "scope-related" do
    let!(     :draft) { create_minimal_instance(:draft    ) }
    let!( :scheduled) { create_minimal_instance(:scheduled) }
    let!( :published) { create_minimal_instance(:published) }
    let!(       :ids) { [draft, scheduled, published].map(&:id) }
    let!(:collection) { described_class.where(id: ids) }

    describe "self#reverse_cron" do
      subject { collection.reverse_cron }

      it "includes all, ordered descending by published_at, published_on, updated_at" do
        is_expected.to eq([draft, scheduled, published])
      end
    end

    context "for status" do
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
          specify { expect(    draft.draft?).to eq(true ) }
          specify { expect(scheduled.draft?).to eq(false) }
          specify { expect(published.draft?).to eq(false) }
        end

        describe "#scheduled?" do
          specify { expect(    draft.scheduled?).to eq(false) }
          specify { expect(scheduled.scheduled?).to eq(true ) }
          specify { expect(published.scheduled?).to eq(false) }
        end

        describe "#published?" do
          specify { expect(    draft.published?).to eq(false) }
          specify { expect(scheduled.published?).to eq(false ) }
          specify { expect(published.published?).to eq(true ) }
        end

        describe "#unpublished" do
          specify { expect(    draft.unpublished?).to eq(true ) }
          specify { expect(scheduled.unpublished?).to eq(true ) }
          specify { expect(published.unpublished?).to eq(false) }
        end
      end
    end
  end

  context "associations" do
    it { is_expected.to have_and_belong_to_many(:tags) }
  end

  context "attributes" do
    context "enums" do
      describe "status" do
        it { is_expected.to define_enum_for(:status) }

        it_behaves_like "an_enumable_model", [:status]
      end
    end
  end

  context "validations" do
    describe "validates type presence" do
      subject { described_class.new }

      before(:each) { subject.valid? }

      it { is_expected.to have_error(type: :blank) }
    end

    context "conditional" do
      context "draft" do
        subject { create_minimal_instance(:draft) }

        it { is_expected.to_not validate_presence_of(:body        ) }
        it { is_expected.to_not validate_presence_of(:published_at) }
        it { is_expected.to_not validate_presence_of(:publish_on  ) }
      end

      context "scheduled" do
        subject { create_minimal_instance(:scheduled) }

        it { is_expected.to     validate_presence_of(:body        ) }
        it { is_expected.to_not validate_presence_of(:published_at) }
        it { is_expected.to     validate_presence_of(:publish_on  ) }

        specify "publish_on is future" do
          is_expected.to be_valid

          subject.publish_on = Date.today

          is_expected.to_not be_valid
        end
      end

      context "published" do
        subject { create_minimal_instance(:published) }

        it { is_expected.to     validate_presence_of(:body        ) }
        it { is_expected.to     validate_presence_of(:published_at) }
        it { is_expected.to_not validate_presence_of(:publish_on  ) }
      end
    end
  end

  context "aasm" do
    let!(    :draft) { create_minimal_instance(:draft    ) }
    let!(:scheduled) { create_minimal_instance(:scheduled) }
    let!(:published) { create_minimal_instance(:published) }

    let(:callbacks) { [
      :ready_to_publish?,
      :set_published_at,
      :clear_published_at,
      :clear_publish_on,
      :cascade_viewable,
      :cascade_viewable,
    ] }

    describe "states" do
      specify { expect(described_class.new).to have_state(:draft    ) }
      specify { expect(              draft).to have_state(:draft    ) }
      specify { expect(          scheduled).to have_state(:scheduled) }
      specify { expect(          published).to have_state(:published) }
    end

    describe "events" do
      before(:each) do
        callbacks.each do |callback|
          allow(    draft).to receive(callback).and_call_original
          allow(scheduled).to receive(callback).and_call_original
          allow(published).to receive(callback).and_call_original
        end
      end

      describe "schedule" do
        before(:each) do
          expect(draft).to receive(:ready_to_publish?)
          expect(draft).to receive(:cascade_viewable)
          expect(draft).to receive(:cascade_viewable)
        end

        specify do
          draft.publish_on = 3.weeks.from_now

          expect(draft.schedule!).to eq(true)
        end
      end

      describe "unschedule" do
        before(:each) do
          expect(scheduled).to receive(:clear_publish_on)
          expect(scheduled).to receive(:cascade_viewable)
          expect(scheduled).to receive(:cascade_viewable)
        end

        specify do
          expect(scheduled.unschedule!).to eq(true)
        end
      end

      describe "publish" do
        before(:each) do
          expect(draft).to receive(:set_published_at)
          expect(draft).to receive(:ready_to_publish?)
          expect(draft).to receive(:cascade_viewable)
          expect(draft).to receive(:cascade_viewable)
        end

        specify do
          expect(draft.publish!).to eq(true)
        end
      end

      describe "unpublish" do
        before(:each) do
          expect(published).to receive(:clear_published_at)
          expect(published).to receive(:cascade_viewable)
          expect(published).to receive(:cascade_viewable)
        end

        specify do
          expect(published.unpublish!).to eq(true)
        end
      end
    end

    describe "booleans" do
      before(:each) do
        allow(    draft).to receive(:ready_to_publish?).and_return(true )
        allow(scheduled).to receive(:ready_to_publish?).and_return(true )
        allow(published).to receive(:ready_to_publish?).and_return(false)
      end

      describe "may_schedule?" do
        specify "on draft" do
          expect(draft).to receive(:ready_to_publish?)

          expect(draft.may_schedule?).to eq(true)
        end

        specify "on scheduled" do
          expect(scheduled).to_not receive(:ready_to_publish?)

          expect(scheduled.may_schedule?).to eq(false)
        end

        specify "on published" do
          expect(published).to_not receive(:ready_to_publish?)

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
          expect(draft).to receive(:ready_to_publish?)

          expect(draft.may_publish?).to eq(true)
        end

        specify "on scheduled" do
          expect(scheduled).to receive(:ready_to_publish?)

          expect(scheduled.may_publish?).to eq(true)
        end

        specify "on published" do
          expect(published).to_not receive(:ready_to_publish?)

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

    describe "private" do
      describe "#ready_to_publish?" do
        subject { build_minimal_instance(:with_body) }

        specify "true if saved, valid and has body" do
          subject.save

          expect(subject.send(:ready_to_publish?)).to eq(true)
        end

        specify "true if scheduled, saved, valid and has body" do
          subject.publish_on = 3.weeks.from_now
          subject.save
          subject.schedule!

          expect(subject.send(:ready_to_publish?)).to eq(true)
        end

        specify "false unless saved" do
          expect(subject.send(:ready_to_publish?)).to eq(false)
        end

        specify "false if published" do
          subject.save
          subject.publish!

          expect(subject.send(:ready_to_publish?)).to eq(false)
        end

        specify "false unless valid" do
          subject.save

          allow(subject.reload).to receive(:valid?).and_return(false)

          expect(subject.send(:ready_to_publish?)).to eq(false)
        end

        specify "false unless body" do
          subject.save
          subject.body = nil

          expect(subject.send(:ready_to_publish?)).to eq(false)
        end
      end

      describe "#set_published_at" do
        subject { create_minimal_instance(:draft) }

        it "sets published_at" do
          Timecop.freeze(2020, 3, 3) do
            subject.send(:set_published_at)

            expect(subject.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            expect(subject.published_at).to eq(DateTime.parse("2020-03-03"))
          end
        end

        it "sets published_at even if already set" do
          subject.update!(published_at: 3.weeks.ago)

          Timecop.freeze(2020, 3, 3) do
            subject.send(:set_published_at)

            expect(subject.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            expect(subject.published_at).to eq(DateTime.parse("2020-03-03"))
          end
        end
      end

      describe "#clear_published_at" do
        it "removes published_at" do
          instance = create_minimal_instance(:published)

          instance.send(:clear_published_at)

          expect(instance.published_at).to eq(nil)
        end
      end

      describe "#clear_publish_on" do
        it "removes publish_on" do
          instance = create_minimal_instance(:published)

          instance.send(:clear_publish_on)

          expect(instance.publish_on).to eq(nil)
        end
      end

      describe "#cascade_viewable" do
        let(:instance) { create_minimal_instance }
        let(  :author) { double }
        let(    :tags) { [double, double] }

        before(:each) do
          allow(instance  ).to receive(:author).and_return(author)
          allow(instance  ).to receive(:tags  ).and_return(tags  )

          allow(author    ).to receive(:update_viewable)
          allow(tags.first).to receive(:update_viewable)
          allow(tags.last ).to receive(:update_viewable)
        end

        it "updates counts for author and tags" do
          expect(author    ).to receive(:update_viewable).once
          expect(tags.first).to receive(:update_viewable).once
          expect(tags.last ).to receive(:update_viewable).once

          instance.send(:cascade_viewable)
        end
      end
    end

    describe "transitions" do
      describe "to draft" do
        specify { expect(    draft).to_not allow_transition_to(:draft) }
        specify { expect(scheduled).to     allow_transition_to(:draft) }
        specify { expect(published).to     allow_transition_to(:draft) }
      end

      describe "to scheduled" do
        specify { expect(    draft).to     allow_transition_to(:scheduled) }
        specify { expect(scheduled).to_not allow_transition_to(:scheduled) }
        specify { expect(published).to_not allow_transition_to(:scheduled) }
      end

      describe "to published" do
        specify { expect(    draft).to     allow_transition_to(:published) }
        specify { expect(scheduled).to     allow_transition_to(:published) }
        specify { expect(published).to_not allow_transition_to(:published) }
      end
    end

    describe "update-transition methods" do
      describe "#update_and_publish" do
        subject { create_minimal_instance(:with_body) }

        before(:each) do
          allow(subject).to receive(:update  ).and_call_original
          allow(subject).to receive(:publish!).and_call_original
        end

        context "valid" do
          let(:params) { { "body" => "New body" } }

          it "publishes" do
            expect(subject.update_and_publish(params)).to eq(true)

            expect(subject.reload).to be_published
          end

          it "calls methods" do
            expect(subject).to receive(:update  )
            expect(subject).to receive(:publish!)

            subject.update_and_publish(params)
          end

          it "updates attributes" do
            subject.update_and_publish(params)

            subject.reload

            expect(subject.body).to eq(params["body"])
          end
        end

        context "invalid" do
          let(:params) { { "body" => "" } }

          before(:each) do
            allow(subject).to receive(:valid?).and_return(false)
          end

          it "does not publish" do
            expect(subject.update_and_publish(params)).to eq(false)

            expect(subject.reload).to_not be_published
          end

          it "calls update but not publish" do
            expect(subject).to     receive(:update  )
            expect(subject).to_not receive(:publish!)

            subject.update_and_publish(params)
          end

          it "updates atributes without saving" do
            subject.update_and_publish(params)

            expect(subject.body         ).to be_blank
            expect(subject.body_changed?).to eq(true)
          end

          it "manually adds errors on empty body" do
            subject.update_and_publish(params)

            is_expected.to have_error(body: :blank)
          end
        end
      end

      describe "#update_and_unpublish" do
        subject { create_minimal_instance(:published) }

        before(:each) do
          allow(subject).to receive(:update    ).and_call_original
          allow(subject).to receive(:unpublish!).and_call_original
        end

        context "valid" do
          let(:params) { { "body" => "New body" } }

          it "unpublishes, updates, and returns true" do
            expect(subject).to receive(:update    )
            expect(subject).to receive(:unpublish!)

            expect(subject.update_and_unpublish(params)).to eq(true)

            subject.reload

            expect(subject.body).to eq(params["body"])

            expect(subject).to be_draft
          end
        end

        context "invalid" do
          let(:params) { { "author_id" => nil, "body" => "" } }

          it "unpublishes, does not update and returns false" do
            expect(subject).to receive(:unpublish!)
            expect(subject).to receive(:update    )

            expect(subject.update_and_unpublish(params)).to eq(false)

            expect(subject.body         ).to be_blank
            expect(subject.body_changed?).to eq(true)

            expect(subject).to be_draft
          end
        end
      end

      describe "#update_and_schedule" do
        subject { create_minimal_instance(:with_body) }

        before(:each) do
          allow(subject).to receive(:update   ).and_call_original
          allow(subject).to receive(:schedule!).and_call_original
        end

        context "valid" do
          let(:params) { { "body" => "New body", "publish_on" => 3.weeks.from_now } }

          it "updates, schedules and returns true" do
            expect(subject).to receive(:update   )
            expect(subject).to receive(:schedule!)

            expect(subject.update_and_schedule(params)).to eq(true)

            subject.reload

            expect(subject).to be_scheduled

            expect(subject.body).to eq(params["body"])
          end
        end

        context "invalid" do
          let(:params) { { "author_id" => nil, "body" => "", "publish_on" => 3.weeks.from_now } }

          it "does not update, does not attempt schedule and returns false" do
            expect(subject).to     receive(:update   )
            expect(subject).to_not receive(:schedule!)

            expect(subject.update_and_schedule(params)).to eq(false)

            expect(subject.publish_on).to be_a_kind_of(ActiveSupport::TimeWithZone)

            expect(subject.body         ).to be_blank
            expect(subject.body_changed?).to eq(true)

            expect(subject.reload).to_not be_scheduled
          end

          it "manually adds errors on empty body" do
            subject.update_and_schedule(params)

            expect(subject.errors.details[:body].first).to eq({ error: :blank })
          end
        end
      end

      describe "#update_and_unschedule" do
        subject { create_minimal_instance(:scheduled) }

        before(:each) do
          allow(subject).to receive(:update     ).and_call_original
          allow(subject).to receive(:unschedule!).and_call_original
        end

        context "valid" do
          let(:params) { { "body" => "" } }

          it "unschedules, updates, and returns true" do
            expect(subject).to receive(:update     )
            expect(subject).to receive(:unschedule!)

            expect(subject.update_and_unschedule(params)).to eq(true)

            expect(subject.body).to be_blank

            expect(subject.reload).to be_draft
          end
        end

        context "invalid" do
          let(:params) { { "author_id" => nil, "body" => "" } }

          it "unschedules, fails update and returns false" do
            expect(subject).to receive(:update     )
            expect(subject).to receive(:unschedule!)

            expect(subject.update_and_unschedule(params)).to eq(false)

            expect(subject.body         ).to be_blank
            expect(subject.body_changed?).to eq(true)

            expect(subject.reload).to be_draft
          end
        end
      end
    end
  end
end
