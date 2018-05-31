# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"
  end

  context "class" do
    describe "self#publish_scheduled" do
      let!(:current) { create(:standalone_post, :scheduled, publish_on: 1.day.from_now) }
      let!( :future) { create(:standalone_post, :scheduled) }

      context "scope :scheduled_ready" do
        it "includes only scheduled posts that have come due" do
          Timecop.freeze(Date.today + 3) do
            expect(described_class.scheduled_ready).to match_array([
              current
            ])
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
    let!(:draft_standalone    ) { create(:standalone_post, :draft    ) }
    let!(:draft_review        ) { create(:review,          :draft    ) }
    let!(:scheduled_standalone) { create(:standalone_post, :scheduled) }
    let!(:scheduled_review    ) { create(:review,          :scheduled) }
    let!(:published_standalone) { create(:standalone_post, :published) }
    let!(:published_review    ) { create(:review,          :published) }

    context "basics" do
      describe "self#eager" do
        subject { described_class.eager }

        it { is_expected.to eager_load(:medium, :work, :creators, :author) }
      end

      describe "self#reverse_cron" do
        subject { described_class.reverse_cron }

        pending "publish_on, updated_at"

        specify do
          is_expected.to contain_exactly(
            draft_standalone,
            draft_review,
            scheduled_standalone,
            scheduled_review,
            published_review,
            published_standalone
          )
        end

        it { is_expected.to_not eager_load(:medium, :work, :creators, :author) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin }

        specify do
          is_expected.to contain_exactly(
            draft_review,
            draft_standalone,
            published_review,
            published_standalone,
            scheduled_review,
            scheduled_standalone
          )
        end

        it { is_expected.to eager_load(:medium, :work, :creators, :author) }
      end

      describe "self#for_site" do
        subject { described_class.for_site }

        it { is_expected.to eq [ published_review, published_standalone ] }

        it { is_expected.to eager_load(:medium, :work, :creators, :author) }
      end
    end

    context "for status" do
      describe "self#draft" do
        subject { described_class.draft }

        specify do
          is_expected.to contain_exactly(
            draft_review,
            draft_standalone
          )
        end
      end

      describe "self#scheduled" do
        subject { described_class.scheduled }

        specify do
          is_expected.to contain_exactly(
            scheduled_standalone,
            scheduled_review
          )
        end
      end

      describe "self#published" do
        subject { described_class.published }

        specify do
          is_expected.to contain_exactly(
            published_review,
            published_standalone
          )
        end
      end

      describe "self#not_published" do
        subject { described_class.not_published }

        specify do
          is_expected.to contain_exactly(
            draft_review,
            draft_standalone,
            scheduled_standalone,
            scheduled_review
          )
        end
      end
    end

    context "for type" do
      describe "self#standalone" do
        subject { described_class.standalone }

        specify do
          is_expected.to contain_exactly(
            draft_standalone,
            published_standalone,
            scheduled_standalone
          )
        end
      end

      describe "self#review" do
        subject { described_class.review }

        specify do
          is_expected.to contain_exactly(
            draft_review,
            published_review,
            scheduled_review
          )
        end
      end
    end
  end

  context "associations" do
    it { is_expected.to have_and_belong_to_many(:tags) }

    it { is_expected.to belong_to(:work) }

    it { is_expected.to have_one(:medium       ).through(:work) }
    it { is_expected.to have_many(:creators    ).through(:work) }
    it { is_expected.to have_many(:contributors).through(:work) }
    it { is_expected.to have_many(:work_tags   ).through(:work) }
  end

  context "attributes" do
    context "virtual" do
      subject { create_minimal_instance }

      describe "#current_work" do
        it { is_expected.to respond_to(:current_work_id ) }
        it { is_expected.to respond_to(:current_work_id=) }
      end
    end

    context "nested" do
      it { is_expected.to accept_nested_attributes_for(:work) }

      describe "reject_if" do
        subject { build(:post, body: "body", work_attributes: { "0" => { "title" => "" } }) }

        it "rejects works with blank titles" do
          expect { subject.save }.to_not change { Work.count }

          expect(subject.work).to eq(nil)
        end
      end
    end

    context "enums" do
      describe "status" do
        it { is_expected.to define_enum_for(:status) }

        it_behaves_like "an_enumable_model", [:status]
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    context "conditional" do
      context "draft" do
        subject { create(:minimal_post, :draft) }

        it { is_expected.to_not validate_presence_of(:body        ) }
        it { is_expected.to_not validate_presence_of(:published_at) }
        it { is_expected.to_not validate_presence_of(:publish_on  ) }
      end

      context "scheduled" do
        subject { create(:minimal_post, :scheduled) }

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
        subject { create(:minimal_post, :published) }

        it { is_expected.to     validate_presence_of(:body        ) }
        it { is_expected.to     validate_presence_of(:published_at) }
        it { is_expected.to_not validate_presence_of(:publish_on  ) }
      end
    end

    context "custom" do
      describe "#has_title_or_postable" do
        context "unsaved" do
          describe "with just work" do
            subject { build(:post, work_id: create(:minimal_work).id) }

            specify "ok" do
              subject.send(:has_title_or_postable)

              expect(subject.errors.details[:base]).to eq([])
            end
          end

          describe "with just title" do
            subject { build(:post, title: "") }

            specify "ok" do
              subject.send(:has_title_or_postable)

              expect(subject.errors.details[:base]).to eq([])
            end
          end

          describe "with neither" do
            subject { build(:post) }

            specify "errors" do
              subject.send(:has_title_or_postable)

              expect(subject.errors.details[:base].first[:error]).to eq(:needs_title_or_postable)
            end
          end

          describe "with both" do
            subject { build(:post, title: "title", work_id: create(:minimal_work).id) }

            specify "errors" do
              subject.send(:has_title_or_postable)

              expect(subject.errors.details[:base].first[:error]).to eq(:has_title_and_postable)
            end
          end
        end

        context "saved review" do
          subject { create(:review) }

          it "ensures work and no title" do
            subject.work_id = ""
            subject.title   = "title"

            subject.send(:has_title_or_postable)

            expect(subject.errors.details[:work_id].first).to eq({ error: :blank   })
            expect(subject.errors.details[:title  ].first).to eq({ error: :present })
          end
        end

        context "saved standalone" do
          subject { create(:standalone_post) }

          it "ensures title and no work" do
            subject.title   = ""
            subject.work_id = create(:minimal_work).id

            subject.send(:has_title_or_postable)

            expect(subject.errors.details[:title  ].first).to eq({ error: :blank   })
            expect(subject.errors.details[:work_id].first).to eq({ error: :present })
          end
        end
      end

      describe "#only_uncategorized_tags" do
        let(:tag_for_post) { create(:tag_for_post) }
        let(:tag_for_work) { create(:tag_for_work) }

        subject { create(:standalone_post) }

        context "valid" do
          it "allows uncategorized tags" do
            subject.update(tag_ids: [tag_for_post.id])

            expect(subject).to_not have_error(tag_ids: :categorized_tags)
          end
        end

        context "invalid" do
          it "disallows categorized tags" do
            subject.update(tag_ids: [tag_for_work.id])

            expect(subject).to have_error(tag_ids: :categorized_tags)
          end
        end
      end
    end
  end

  context "aasm" do
    let!(    :draft) { create(:standalone_post, :with_body, :draft    ) }
    let!(:scheduled) { create(:standalone_post, :with_body, :scheduled) }
    let!(:published) { create(:standalone_post, :with_body, :published) }

    describe "states" do
      specify { expect( Post.new).to have_state(:draft    ) }
      specify { expect(    draft).to have_state(:draft    ) }
      specify { expect(scheduled).to have_state(:scheduled) }
      specify { expect(published).to have_state(:published) }
    end

    describe "events" do
      describe "schedule" do
        context "callbacks" do
          describe "guards" do
            specify "calls #ready_to_publish?" do
               allow(draft).to receive(:ready_to_publish?).and_call_original
              expect(draft).to receive(:ready_to_publish?)

              draft.publish_on = 3.weeks.from_now

              expect(draft.schedule!).to eq(true)
            end
          end

          describe "after" do
            it "calls #update_counts_for_descendents" do
               allow(draft).to receive(:update_counts_for_descendents).and_call_original
              expect(draft).to receive(:update_counts_for_descendents)

              draft.publish_on = 3.weeks.from_now

              expect(draft.schedule!).to eq(true)
            end
          end
        end
      end

      describe "unschedule" do
        context "callbacks" do
          describe "before" do
            it "calls #clear_publish_on" do
               allow(scheduled).to receive(:clear_publish_on).and_call_original
              expect(scheduled).to receive(:clear_publish_on)

              expect(scheduled.unschedule!).to eq(true)
            end
          end

          describe "after" do
            it "calls #update_counts_for_descendents" do
               allow(scheduled).to receive(:update_counts_for_descendents).and_call_original
              expect(scheduled).to receive(:update_counts_for_descendents)

              expect(scheduled.unschedule!).to eq(true)
            end
          end
        end
      end

      describe "publish" do
        context "callbacks" do
          describe "before" do
            it "calls #set_published_at" do
               allow(draft).to receive(:set_published_at).and_call_original
              expect(draft).to receive(:set_published_at)

              expect(draft.publish!).to eq(true)
            end
          end

          describe "guards" do
            specify "calls #ready_to_publish?" do
               allow(draft).to receive(:ready_to_publish?).and_call_original
              expect(draft).to receive(:ready_to_publish?)

              expect(draft.publish!).to eq(true)
            end
          end

          describe "after" do
            it "calls #update_counts_for_descendents" do
               allow(draft).to receive(:update_counts_for_descendents).and_call_original
              expect(draft).to receive(:update_counts_for_descendents)

              expect(draft.publish!).to eq(true)
            end
          end
        end
      end

      describe "unpublish" do
        context "callbacks" do
          describe "before" do
            it "calls #clear_published_at" do
               allow(published).to receive(:clear_published_at).and_call_original
              expect(published).to receive(:clear_published_at)

              expect(published.unpublish!).to eq(true)
            end
          end

          describe "after" do
            it "calls #update_counts_for_descendents" do
               allow(published).to receive(:update_counts_for_descendents).and_call_original
              expect(published).to receive(:update_counts_for_descendents)

              expect(published.unpublish!).to eq(true)
            end
          end
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

    describe "scopes" do
      specify { expect(described_class.draft    ).to be_a_kind_of(ActiveRecord::Relation) }
      specify { expect(described_class.scheduled).to be_a_kind_of(ActiveRecord::Relation) }
      specify { expect(described_class.published).to be_a_kind_of(ActiveRecord::Relation) }
    end

    describe "private" do
      context "guards" do
        describe "#ready_to_publish?" do
          subject { build(:standalone_post, :with_body) }

          specify "true if saved, valid and has slug & body" do
            subject.save

            expect(subject.send(:ready_to_publish?)).to eq(true)
          end

          specify "true if scheduled, saved, valid and has slug & body" do
            subject.publish_on = 3.weeks.from_now
            subject.save
            subject.schedule!

            expect(subject.send(:ready_to_publish?)).to eq(true)
          end

          specify "false unless saved" do
            subject.slug = "foo_bar_bat"

            expect(subject.send(:ready_to_publish?)).to eq(false)
          end

          specify "false if published" do
            subject.save
            subject.publish!

            expect(subject.send(:ready_to_publish?)).to eq(false)
          end

          specify "false unless valid" do
            subject.save
            subject.title = nil

            expect(subject.send(:ready_to_publish?)).to eq(false)
          end

          specify "false unless slug" do
            subject.save
            subject.slug = nil

            expect(subject.send(:ready_to_publish?)).to eq(false)
          end

          specify "false unless body" do
            subject.save
            subject.body = nil

            expect(subject.send(:ready_to_publish?)).to eq(false)
          end
        end
      end

      context "callbacks" do
        describe "#set_published_at" do
          subject { create(:standalone_post, :draft) }

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
            instance = create(:standalone_post, :published)

            instance.send(:clear_published_at)

            expect(instance.published_at).to eq(nil)
          end
        end

        describe "#clear_publish_on" do
          it "removes publish_on" do
            instance = create(:standalone_post, :published)

            instance.send(:clear_publish_on)

            expect(instance.publish_on).to eq(nil)
          end
        end

        describe "#update_counts_for_descendents" do
          context "review" do
            let(        :post) { create(:unity_album_review) }
            let(      :author) { double }
            let(        :tags) { [double, double] }
            let(        :work) { double }
            let(   :work_tags) { [double, double] }
            let(      :medium) { double }
            let(    :creators) { [double, double] }
            let(:contributors) { [double, double] }

            it "updates counts for all author, tags and all work-related descendents" do
              allow(post).to receive(      :author).and_return(author      )
              allow(post).to receive(        :tags).and_return(tags        )
              allow(post).to receive(        :work).and_return(work        )
              allow(post).to receive(   :work_tags).and_return(work_tags   )
              allow(post).to receive(      :medium).and_return(medium      )
              allow(post).to receive(    :creators).and_return(creators    )
              allow(post).to receive(:contributors).and_return(contributors)

              allow(            author).to receive(:update_counts)
              allow(        tags.first).to receive(:update_counts)
              allow(         tags.last).to receive(:update_counts)
              allow(              work).to receive(:update_counts)
              allow(   work_tags.first).to receive(:update_counts)
              allow(    work_tags.last).to receive(:update_counts)
              allow(            medium).to receive(:update_counts)
              allow(    creators.first).to receive(:update_counts)
              allow(     creators.last).to receive(:update_counts)
              allow(contributors.first).to receive(:update_counts)
              allow( contributors.last).to receive(:update_counts)

              expect(            author).to receive(:update_counts).once
              expect(        tags.first).to receive(:update_counts).once
              expect(         tags.last).to receive(:update_counts).once
              expect(              work).to receive(:update_counts).once
              expect(   work_tags.first).to receive(:update_counts).once
              expect(    work_tags.last).to receive(:update_counts).once
              expect(            medium).to receive(:update_counts).once
              expect(    creators.first).to receive(:update_counts).once
              expect(     creators.last).to receive(:update_counts).once
              expect(contributors.first).to receive(:update_counts).once
              expect( contributors.last).to receive(:update_counts).once

              post.send(:update_counts_for_descendents)
            end
          end

          context "standalone" do
            let(  :post) { create(:standalone_post) }
            let(:author) { double }
            let(  :tags) { [double, double] }

            it "updates counts for author and tags" do
              allow(      post).to receive(:author).and_return(author)
              allow(      post).to receive(:tags  ).and_return(tags  )

              allow(    author).to receive(:update_counts)
              allow(tags.first).to receive(:update_counts)
              allow( tags.last).to receive(:update_counts)

              expect(    author).to receive(:update_counts).once
              expect(tags.first).to receive(:update_counts).once
              expect( tags.last).to receive(:update_counts).once

              post.send(:update_counts_for_descendents)
            end
          end
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
        subject { create(:standalone_post, :with_body) }

        before(:each) do
          allow(subject).to receive(:update  ).and_call_original
          allow(subject).to receive(:publish!).and_call_original
        end

        context "valid" do
          let(:params) { { "title" => "New title" } }

          it "updates, publishes and returns true" do
            expect(subject).to receive(:update  )
            expect(subject).to receive(:publish!)

            expect(subject.update_and_publish(params)).to eq(true)

            subject.reload

            expect(subject.title).to eq(params["title"])

            expect(subject).to be_published
          end
        end

        context "invalid" do
          let(:params) { { "title" => "", "body" => "" } }

          it "does not update, does not attempt publish and returns false" do
            expect(subject).to     receive(:update  )
            expect(subject).to_not receive(:publish!)

            expect(subject.update_and_publish(params)).to eq(false)

            expect(subject.title).to eq(nil)

            subject.reload

            expect(subject.title).to_not eq(nil)

            expect(subject).to_not be_published
          end

          it "manually adds errors on empty body" do
            subject.update_and_publish(params)

            expect(subject.errors.details[:body].first).to eq({ error: :blank_during_publish })
          end
        end
      end

      describe "#update_and_unpublish" do
        subject { create(:review, :published) }

        before(:each) do
          allow(subject).to receive(:update    ).and_call_original
          allow(subject).to receive(:unpublish!).and_call_original
        end

        context "valid" do
          let(:params) { { "work_id" => create(:minimal_work).id } }

          it "unpublishes, updates, and returns true" do
            expect(subject).to receive(:update    )
            expect(subject).to receive(:unpublish!)

            expect(subject.update_and_unpublish(params)).to eq(true)

            subject.reload

            expect(subject.work_id).to eq(params["work_id"])

            expect(subject).to_not be_published
          end
        end

        context "invalid" do
          let(:params) { { "work_id" => "", "body" => "" } }

          it "unpublishes, does not update and returns false" do
            expect(subject).to receive(:update    )
            expect(subject).to receive(:unpublish!)

            expect(subject.update_and_unpublish(params)).to eq(false)

            expect(subject.work_id).to eq(nil)

            subject.reload

            expect(subject.work_id).to_not eq(nil)

            expect(subject).to_not be_published
          end
        end
      end

      describe "#update_and_schedule" do
        subject { create(:standalone_post, :with_body) }

        before(:each) do
          allow(subject).to receive(:update   ).and_call_original
          allow(subject).to receive(:schedule!).and_call_original
        end

        context "valid" do
          let(:params) { { "title" => "New title", "publish_on" => 3.weeks.from_now } }

          it "updates, schedules and returns true" do
            expect(subject).to receive(:update   )
            expect(subject).to receive(:schedule!)

            expect(subject.update_and_schedule(params)).to eq(true)

            subject.reload

            expect(subject).to be_scheduled

            expect(subject.title).to eq(params["title"])
          end
        end

        context "invalid" do
          let(:params) { { "title" => "", "body" => "", "publish_on" => 3.weeks.from_now } }

          it "does not update, does not attempt schedule and returns false" do
            expect(subject).to     receive(:update   )
            expect(subject).to_not receive(:schedule!)

            expect(subject.update_and_schedule(params)).to eq(false)

            expect(subject.title     ).to eq(nil)
            expect(subject.body      ).to eq(nil)
            expect(subject.publish_on).to be_a_kind_of(ActiveSupport::TimeWithZone)

            subject.reload

            expect(subject.title).to_not eq(nil)

            expect(subject).to_not be_scheduled
          end

          it "manually adds errors on empty body" do
            subject.update_and_schedule(params)

            expect(subject.errors.details[:body].first).to eq({ error: :blank_during_publish })
          end
        end
      end

      describe "#update_and_unschedule" do
        subject { create(:review, :scheduled) }

        before(:each) do
          allow(subject).to receive(:update     ).and_call_original
          allow(subject).to receive(:unschedule!).and_call_original
        end

        context "valid" do
          let(:params) { { "work_id" => create(:minimal_work).id } }

          it "unschedules, updates, and returns true" do
            expect(subject).to receive(:update     )
            expect(subject).to receive(:unschedule!)

            expect(subject.update_and_unschedule(params)).to eq(true)

            subject.reload

            expect(subject.work_id).to eq(params["work_id"])

            expect(subject).to_not be_scheduled
          end
        end

        context "invalid" do
          let(:params) { { "work_id" => "" } }

          it "unschedules, fails update and returns false" do
            expect(subject).to receive(:update     )
            expect(subject).to receive(:unschedule!)

            expect(subject.update_and_unschedule(params)).to eq(false)

            expect(subject.work_id).to eq(nil)

            subject.reload

            expect(subject.work_id).to_not eq(nil)

            expect(subject).to_not be_scheduled
          end
        end
      end
    end
  end

  context "instance" do
    context "decorators" do
      let(:standalone) { create(:standalone_post) }
      let(    :review) { create(:song_review    ) }

      describe "#type" do
        specify { expect(standalone.type              ).to eq("Post"         ) }
        specify { expect(standalone.type(plural: true)).to eq("Posts"        ) }
        specify { expect(    review.type              ).to eq("Song Review" ) }
        specify { expect(    review.type(plural: true)).to eq("Song Reviews") }
      end
    end

    context "booleans" do
      context "for type" do
        let(:unsaved_standalone) {  build(:standalone_post) }
        let(  :saved_standalone) { create(:standalone_post) }
        let(    :unsaved_review) {  build(:review    ) }
        let(      :saved_review) { create(:review    ) }

        describe "#standalone?" do
          specify { expect(unsaved_standalone.standalone?).to eq(true ) }
          specify { expect(  saved_standalone.standalone?).to eq(true ) }
          specify { expect(    unsaved_review.standalone?).to eq(false) }
          specify { expect(      saved_review.standalone?).to eq(false) }

          context "while editing saved" do
            specify "true for standalone even if title nil" do
              saved_standalone.title = nil

              expect(saved_standalone.standalone?).to eq(true)
            end

            specify "false for review even if work nil" do
              saved_review.work = nil

              expect(saved_review.standalone?).to eq(false)
            end

            specify "false for review even if work_id nil" do
              saved_review.work_id = nil

              expect(saved_review.standalone?).to eq(false)
            end
          end
        end

        describe "#review?" do
          specify { expect(unsaved_standalone.review?).to eq(false) }
          specify { expect(  saved_standalone.review?).to eq(false) }
          specify { expect(    unsaved_review.review?).to eq(true ) }
          specify { expect(      saved_review.review?).to eq(true ) }

          context "while editing saved" do
            specify "false for standalone even if title nil" do
              saved_standalone.title = nil

              expect(saved_standalone.review?).to eq(false)
            end

            specify "true for review even if work nil" do
              saved_review.work = nil

              expect(saved_review.review?).to eq(true)
            end

            specify "true for review even if work_id nil" do
              saved_review.work_id = nil

              expect(saved_review.review?).to eq(true)
            end
          end
        end
      end

      context "for publication status" do
        let(    :draft) { create(:standalone_post, :draft    ) }
        let(:scheduled) { create(:standalone_post, :scheduled) }
        let(:published) { create(:standalone_post, :published) }

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
          specify { expect(    draft.unpublished).to eq(true ) }
          specify { expect(scheduled.unpublished).to eq(true ) }
          specify { expect(published.unpublished).to eq(false) }
        end
      end
    end

    describe "#prepare_work_for_editing" do
      context "review" do
        context "saved" do
          subject { create(:review) }

          let!(      :work_id) { subject.work_id }
          let!(:other_work_id) { create(:minimal_work).id }

          describe "clean" do
            it "moves current_work_id to saved work_id and sets up work_attributes" do
              subject.prepare_work_for_editing

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(work_id)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "current work_id" do
            it "moves current_work_id to saved work_id and sets up work_attributes" do
              subject.prepare_work_for_editing({ "work_id" => work_id })

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(work_id)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "dirty work_id" do
            it "moves current_work_id to dirty work_id and sets up work_attributes" do
              subject.work_id = other_work_id

              subject.prepare_work_for_editing({ "work_id" => other_work_id })

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(other_work_id)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "nil work_id" do
            it "nils work_id and current_work_id and sets up work_attributes" do
              subject.work_id = nil

              subject.prepare_work_for_editing({ "work_id" => nil })

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(nil)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "dirty work_attributes" do
            let(:valid_attributes) { {
              "medium_id"          => create(:minimal_medium).id,
              "title"              => "Hounds of Love",
              "credits_attributes" => { "0" => { "creator_id" => create(:minimal_creator).id } }
            } }

            let(:invalid_attributes) {
              valid_attributes.except(:medium_id)
            }

            context "and clean work_id" do
              it "sets current_work_id to current work_id and retains work_attributes" do
                subject.work_id         = work_id
                subject.work_attributes = valid_attributes

                subject.prepare_work_for_editing(valid_attributes.merge({ "work_id" => work_id }))

                expect(subject.changed?       ).to eq(true)
                expect(subject.current_work_id).to eq(work_id)
                expect(subject.work_id        ).to eq(nil)
                expect(subject.work           ).to be_a_populated_new_work
                expect(subject.work.title     ).to eq("Hounds of Love")
              end
            end

            context "and dirty work_id" do
              it "sets current_work_id to dirty work_id and retains work_attributes" do
                subject.work_id         = other_work_id
                subject.work_attributes = valid_attributes

                subject.prepare_work_for_editing(valid_attributes.merge({ "work_id" => other_work_id }))

                expect(subject.changed?       ).to eq(true)
                expect(subject.current_work_id).to eq(other_work_id)
                expect(subject.work_id        ).to eq(nil)
                expect(subject.work           ).to be_a_populated_new_work
              end
            end

            context "and nil work_id" do
              it "sets current_work_id to nil and retains work_attributes" do
                subject.work_id         = nil
                subject.work_attributes = valid_attributes

                subject.prepare_work_for_editing(valid_attributes.merge({ "work_id" => nil }))

                expect(subject.changed?       ).to eq(true)
                expect(subject.current_work_id).to eq(nil)
                expect(subject.work_id        ).to eq(nil)
                expect(subject.work           ).to be_a_populated_new_work
                expect(subject.work.title     ).to eq("Hounds of Love")
              end
            end
          end
        end

        context "unsaved" do
          subject { build(:review) }

          let!(      :work_id) { subject.work_id }
          let!(:other_work_id) { create(:minimal_work).id }

          describe "clean" do
            it "moves current_work_id to saved work_id and sets up work_attributes" do
              subject.prepare_work_for_editing()

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(work_id)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "current work_id" do
            it "moves current_work_id to saved work_id and sets up work_attributes" do
              subject.prepare_work_for_editing({ "work_id" => work_id })

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(work_id)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "dirty work_id" do
            it "moves current_work_id to dirty work_id and sets up work_attributes" do
              subject.work_id = other_work_id

              subject.prepare_work_for_editing({ "work_id" => other_work_id })

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(other_work_id)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "nil work_id" do
            it "nils work_id and current_work_id and sets up work_attributes" do
              subject.work_id = nil

              subject.prepare_work_for_editing({ "work_id" => nil })

              expect(subject.changed?       ).to eq(true)
              expect(subject.current_work_id).to eq(nil)
              expect(subject.work_id        ).to eq(nil)
              expect(subject.work           ).to be_a_populated_new_work
            end
          end

          describe "dirty work_attributes" do
            let(:valid_attributes) { {
              "medium_id"                => create(:minimal_medium).id,
              "title"                    => "Hounds of Love",
              "contributions_attributes" => { "0" => { "creator_id" => create(:minimal_creator).id } }
            } }

            let(:invalid_attributes) {
              valid_attributes.except(:medium_id)
            }

            context "and clean work_id" do
              it "sets current_work_id to current work_id and retains work_attributes" do
                subject.work_id         = work_id
                subject.work_attributes = valid_attributes

                subject.prepare_work_for_editing(valid_attributes.merge({ "work_id" => work_id }))

                expect(subject.changed?       ).to eq(true)
                expect(subject.current_work_id).to eq(work_id)
                expect(subject.work_id        ).to eq(nil)
                expect(subject.work           ).to be_a_populated_new_work
                expect(subject.work.title     ).to eq("Hounds of Love")
              end
            end

            context "and dirty work_id" do
              it "sets current_work_id to dirty work_id and retains work_attributes" do
                subject.work_id         = other_work_id
                subject.work_attributes = valid_attributes

                subject.prepare_work_for_editing(valid_attributes.merge({ "work_id" => other_work_id }))

                expect(subject.changed?       ).to eq(true)
                expect(subject.current_work_id).to eq(other_work_id)
                expect(subject.work_id        ).to eq(nil)
                expect(subject.work           ).to be_a_populated_new_work
              end
            end

            context "and nil work_id" do
              it "sets current_work_id to nil and retains work_attributes" do
                subject.work_id         = nil
                subject.work_attributes = valid_attributes

                subject.prepare_work_for_editing(valid_attributes.merge({ "work_id" => nil }))

                expect(subject.changed?       ).to eq(true)
                expect(subject.current_work_id).to eq(nil)
                expect(subject.work_id        ).to eq(nil)
                expect(subject.work           ).to be_a_populated_new_work
                expect(subject.work.title     ).to eq("Hounds of Love")
              end
            end
          end
        end
      end

      context "standalone" do
        context "saved" do
          subject { create(:standalone_post) }

          it "does nothing" do
            subject.prepare_work_for_editing

            expect(subject.work_id_changed?).to eq(false)
          end
        end

        context "unsaved" do
          subject { build(:standalone_post) }

          it "does nothing" do
            subject.prepare_work_for_editing

            expect(subject.work_id_changed?).to eq(false)
          end
        end
      end
    end

    describe "#alpha_parts" do
      subject { create_minimal_instance }

      context "standalone" do
        subject { create(:standalone_post) }

        it "uses title" do
          expect(subject.alpha_parts).to eq([subject.title])
        end
      end

      context "review" do
        subject { create(:review) }

        it "uses name" do
          expect(subject.alpha_parts).to eq([subject.work.alpha_parts])
        end
      end
    end

    describe "#sluggable_parts" do
      let(    :review) { create(:hounds_of_love_album_review               ) }
      let(    :collab) { create(:unity_album_review                        ) }
      let(:standalone) { create(:standalone_post, title: "Standalone Title") }

      specify "for review" do
        expect(review.send(:sluggable_parts)) .to eq(["reviews", "Albums", "Kate Bush", "Hounds of Love", nil])
      end

      specify "for review of collaborative work" do
        expect(collab.send(:sluggable_parts)).to eq(["reviews", "Albums", "Carl Craig and Green Velvet", "Unity", nil])
      end

      specify "for standalone" do
        expect(standalone.send(:sluggable_parts)).to eq(["Standalone Title"])
      end
    end

    describe "#all_tags" do
      let(:instance) { create_minimal_instance }

      subject { instance.all_tags }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end
  end
end
