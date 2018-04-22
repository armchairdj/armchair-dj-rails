require "rails_helper"

RSpec.describe Post, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an application record"

    it_behaves_like "a sluggable model", :slug

    it_behaves_like "an atomically validatable model", { body: nil, slug: nil, published_at: nil } do
      subject { create(:standalone_post, :published) }
    end
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "Draft",
          "Published",
          "All",
        ])
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:draft) }
    end
  end

  context "scopes" do
    let!(        :draft_review) { create(:song_review,     :draft    ) }
    let!(    :published_review) { create(:song_review,     :published) }
    let!(    :draft_standalone) { create(:standalone_post, :draft    ) }
    let!(:published_standalone) { create(:standalone_post, :published) }

    context "for status" do
      describe "draft" do
        specify { expect(described_class.draft).to match_array([
          draft_review,
          draft_standalone
        ]) }
      end

      describe "published" do
        specify { expect(described_class.published).to match_array([
          published_review,
          published_standalone
        ]) }
      end
    end

    context "for type" do
      describe "standalone" do
        specify { expect(described_class.standalone).to match_array([
          draft_standalone,
          published_standalone
        ]) }
      end

      describe "review" do
        specify { expect(described_class.review).to match_array([
          draft_review,
          published_review
        ]) }
      end
    end

    describe "reverse_cron" do
      specify { expect(described_class.reverse_cron.to_a).to eq([
        draft_review,
        draft_standalone,
        published_standalone,
        published_review,
      ]) }
    end

    pending "eager"

    describe "for_admin" do
      specify { expect(described_class.for_admin).to match_array([
        draft_review,
        draft_standalone,
        published_standalone,
        published_review
      ]) }
    end

    describe "for_site" do
      specify { expect(described_class.for_site).to match_array([
        published_standalone,
        published_review
      ]) }
    end
  end

  context "associations" do
    it { should belong_to(:work) }
  end

  context "attributes" do
    context "virtual" do
      describe "#current_work" do
        it { should respond_to(:current_work_id ) }
        it { should respond_to(:current_work_id=) }
      end
    end

    context "nested" do
      it { should accept_nested_attributes_for(:work) }

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
        it { should define_enum_for(:status) }

        it_behaves_like "an enumable model", [:status]
      end
    end
  end

  context "validations" do
    context "conditional" do
      subject { create(:minimal_post, :published) }

      context "published" do
        it { should validate_presence_of(:body) }
        it { should validate_presence_of(:published_at) }
        it { should validate_presence_of(:slug) }
      end
    end

    context "custom" do
      it "calls #validate_work_and_title" do
         allow(subject).to receive(:validate_work_and_title).and_call_original
        expect(subject).to receive(:validate_work_and_title)

        subject.valid?
      end
    end
  end

  context "hooks" do
    context "before_save" do
      context "calls #handle_slug" do
        before(:each) do
           allow(subject).to receive(:handle_slug).and_call_original
          expect(subject).to receive(:handle_slug)
        end

        context "on new" do
          subject { build(:minimal_post) }

          specify { subject.save }
        end

        context "on saved" do
          subject { create(:minimal_post) }

          specify { subject.save }
        end
      end
    end
  end

  context "aasm" do
    let!(    :draft) { create(:standalone_post            ) }
    let!(:published) { create(:standalone_post, :published) }

    describe "states" do
      specify { expect( Post.new).to have_state(:draft    ) }
      specify { expect(    draft).to have_state(:draft    ) }
      specify { expect(published).to have_state(:published) }
    end

    describe "booleans" do
      describe "may_publish?" do
        before(:each) do
          allow(    draft).to receive(:can_publish?  ).and_return(true )
          allow(published).to receive(:can_publish?  ).and_return(false)
        end

        specify "on published" do
          expect(published).to_not receive(:can_publish?)

          expect(published.may_publish?).to eq(false)
        end

        specify "on draft" do
          expect(draft).to receive(:can_publish?)

          expect(draft.may_publish?).to eq(true)
        end
      end

      describe "may_unpublish?" do
        before(:each) do
          allow(    draft).to receive(:can_unpublish?).and_return(false)
          allow(published).to receive(:can_unpublish?).and_return(true )
        end

        specify "on draft" do
          expect(draft).to_not receive(:can_unpublish?)

          expect(draft.may_unpublish?).to eq(false)
        end

        specify "on published" do
          expect(published).to receive(:can_unpublish?)

          expect(published.may_unpublish?).to eq(true)
        end
      end
    end

    describe "transitions" do
      describe "publish" do
        specify { expect(    draft).to     allow_transition_to(:published) }
        specify { expect(published).to_not allow_transition_to(:published) }
      end

      describe "unpublish" do
        specify { expect(published).to     allow_transition_to(:draft) }
        specify { expect(    draft).to_not allow_transition_to(:draft) }
      end
    end

    describe "events" do
      describe "publish" do
        context "callbacks" do
          describe "before" do
            it "calls #prepare_to_publish" do
               allow(draft).to receive(:prepare_to_publish).and_call_original
              expect(draft).to receive(:prepare_to_publish)

              expect(draft.publish!).to eq(true)
            end
          end

          describe "guards" do
            specify "calls #can_publish?" do
               allow(draft).to receive(:can_publish?).and_call_original
              expect(draft).to receive(:can_publish?)

              expect(draft.publish!).to eq(true)
            end
          end

          describe "after" do
            it "calls #update_viewable_counts" do
               allow(draft).to receive(:update_viewable_counts).and_call_original
              expect(draft).to receive(:update_viewable_counts)

              expect(draft.publish!).to eq(true)
            end
          end
        end
      end

      describe "unpublish" do
        context "callbacks" do
          describe "before" do
            it "calls #prepare_to_unpublish" do
               allow(published).to receive(:prepare_to_unpublish).and_call_original
              expect(published).to receive(:prepare_to_unpublish)

              expect(published.unpublish!).to eq(true)
            end
          end

          describe "guards" do
            specify "calls #can_unpublish?" do
               allow(published).to receive(:can_unpublish?).and_call_original
              expect(published).to receive(:can_unpublish?)

              expect(published.unpublish!).to eq(true)
            end
          end

          describe "after" do
            it "calls #update_viewable_counts" do
               allow(published).to receive(:update_viewable_counts).and_call_original
              expect(published).to receive(:update_viewable_counts)

              expect(published.unpublish!).to eq(true)
            end
          end
        end
      end
    end

    describe "scopes" do
      specify { expect(described_class.draft    ).to be_a_kind_of(ActiveRecord::Relation) }
      specify { expect(described_class.published).to be_a_kind_of(ActiveRecord::Relation) }
    end

    describe "methods" do
      specify { expect(draft).to respond_to(:draft?    ) }
      specify { expect(draft).to respond_to(:published?) }
    end
  end

  context "instance" do
    context "booleans" do
      let(:unsaved_standalone) {  build(:standalone_post) }
      let(  :saved_standalone) { create(:standalone_post) }
      let(    :unsaved_review) {  build(:song_review    ) }
      let(      :saved_review) { create(:song_review    ) }

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

    describe "#prepare_work_for_editing" do
      context "review" do
        context "saved" do
          subject { create(:song_review) }

          let!(      :song_id) { subject.work_id }
          let!(:other_song_id) { create(:song).id }

          describe "clean" do
            it "moves saved work_id to current_work_id and sets up work_attributes" do
              subject.prepare_work_for_editing

              expect(subject.changed?                 ).to eq(true)
              expect(subject.current_work_id          ).to eq(song_id)
              expect(subject.work_id                  ).to eq(nil)
              expect(subject.work                     ).to be_a_new(Work)
              expect(subject.work.contributions.length).to eq(10)
            end
          end

          describe "dirty work_id" do
            it "moves dirty work_id to current_work_id and sets up work_attributes" do
              subject.work_id = other_song_id

              subject.prepare_work_for_editing

              expect(subject.changed?                 ).to eq(true)
              expect(subject.current_work_id          ).to eq(other_song_id)
              expect(subject.work_id                  ).to eq(nil)
              expect(subject.work                     ).to be_a_new(Work)
              expect(subject.work.contributions.length).to eq(10)
            end
          end

          describe "nil work_id" do
            it "nils work_id and current_work_id and sets up work_attributes" do
              subject.work_id = nil

              subject.prepare_work_for_editing

              expect(subject.changed?                 ).to eq(true)
              expect(subject.current_work_id          ).to eq(nil)
              expect(subject.work_id                  ).to eq(nil)
              expect(subject.work                     ).to be_a_new(Work)
              expect(subject.work.contributions.length).to eq(10)
            end
          end

          describe "dirty work_attributes" do
            it "sets saved work_id to current_work_id and sets up work_attributes" do
              subject.work_id = nil

              subject.prepare_work_for_editing

              expect(subject.changed?                 ).to eq(true)
              expect(subject.current_work_id          ).to eq(nil)
              expect(subject.work_id                  ).to eq(nil)
              expect(subject.work                     ).to be_a_new(Work)
              expect(subject.work.contributions.length).to eq(10)
            end
          end
        end

        pending "unsaved"
      end

      context "standalone" do
        context "unsaved" do
          subject { build(:standalone_post) }

          it "does nothing" do
            subject.prepare_work_for_editing

            expect(subject.changed?).to eq(false)
          end
        end

        context "saved" do
          subject { create(:standalone_post) }

          it "does nothing" do
            subject.prepare_work_for_editing

            expect(subject.changed?).to eq(false)
          end
        end
      end
    end

    describe "#update_and_publish" do
      before(:each) do
        allow(subject).to receive(:update  ).and_call_original
        allow(subject).to receive(:publish!).and_call_original
      end

      subject { create(:standalone_post) }

      context "valid params and valid transition" do
        let(:params) { { "title" => "New title" } }

        it "updates, publishes and returns true" do
          expect(subject).to receive(:update  )
          expect(subject).to receive(:publish!)

          expect(subject.update_and_publish(params)).to eq(true)

          subject.reload

          expect(subject.title       ).to eq(params["title"])
          expect(subject.published?  ).to eq(true)
          expect(subject.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
        end
      end

      context "valid params and invalid transition" do
        let(:params) { { "title" => "New title" } }

        before(:each) do
          allow(subject).to receive(:can_publish?).and_return(false)
        end

        it "updates, attempts publish and returns false" do
          expect(subject).to receive(:update  )
          expect(subject).to receive(:publish!)

          expect(subject.update_and_publish(params)).to eq(false)

          subject.reload

          expect(subject.title       ).to eq(params["title"])
          expect(subject.published?  ).to eq(false)
          expect(subject.published_at).to eq(nil)
        end
      end

      context "invalid params" do
        let(:params) { { "title" => "", "body" => "" } }

        it "does not update, does not attempt publish and returns false" do
          expect(subject).to     receive(:update  )
          expect(subject).to_not receive(:publish!)

          expect(subject.update_and_publish(params)).to eq(false)

          expect(subject.title).to eq(nil)

          subject.reload

          expect(subject.title       ).to_not eq(nil)
          expect(subject.published?  ).to     eq(false)
          expect(subject.published_at).to     eq(nil)
        end

        it "manually adds errors on empty body" do
          subject.update_and_publish(params)

          expect(subject.errors.details[:body].first).to eq({ error: :blank_during_publish })
        end
      end
    end

    describe "#update_and_unpublish" do
      before(:each) do
        allow(subject).to receive(:update    ).and_call_original
        allow(subject).to receive(:unpublish!).and_call_original
      end

      subject { create(:song_review, :published) }

      context "valid params and valid transition" do
        let(:params) { { "work_id" => create(:song).id } }

        it "unpublishes, updates, and returns true" do
          expect(subject).to receive(:update    )
          expect(subject).to receive(:unpublish!)

          expect(subject.update_and_unpublish(params)).to eq(true)

          subject.reload

          expect(subject.work_id     ).to eq(params["work_id"])
          expect(subject.published?  ).to eq(false)
          expect(subject.published_at).to eq(nil)
        end
      end

      context "valid params and invalid transition" do
        let(:params) { { "work_id" => create(:song).id } }

        before(:each) do
          allow(subject).to receive(:can_unpublish?).and_return(false)
        end

        it "attempts unpublish, updates and returns false" do
          expect(subject).to receive(:update    )
          expect(subject).to receive(:unpublish!)

          expect(subject.update_and_unpublish(params)).to eq(false)

          subject.reload

          expect(subject.work_id     ).to eq(params["work_id"])
          expect(subject.published?  ).to eq(true)
          expect(subject.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
        end
      end

      context "invalid params" do
        let(:params) { { "work_id" => "", "body" => "" } }

        it "unpublishes, does not update and returns false" do
          expect(subject).to receive(:update    )
          expect(subject).to receive(:unpublish!)

          expect(subject.update_and_unpublish(params)).to eq(false)

          expect(subject.work_id).to eq(nil)

          subject.reload

          expect(subject.work_id     ).to_not eq(nil)
          expect(subject.published?  ).to     eq(false)
          expect(subject.published_at).to     eq(nil)
        end
      end
    end

    describe "private" do
      context "callbacks" do
        describe "#sluggable_parts" do
          let(    :review) { create(:hounds_of_love_album_review               ) }
          let(    :collab) { create(:unity_album_review                        ) }
          let(:standalone) { create(:standalone_post, title: "Standalone Title") }

          specify "for review" do
            expect(review.send(:sluggable_parts)) .to eq(["Album", "Kate Bush", "Hounds of Love"])
          end

          specify "for review of collaborative work" do
            expect(collab.send(:sluggable_parts)).to eq(["Album", "Carl Craig and Green Velvet", "Unity"])
          end

          specify "for standalone" do
            expect(standalone.send(:sluggable_parts)).to eq(["Standalone Title"])
          end
        end

        describe "#handle_slug" do
          before(:each) do
            allow(instance).to receive(:sluggable_parts).and_return(["Standalone Title"])

            allow(instance).to receive(:slugify).and_call_original

            allow(instance).to receive(:generate_slug).with(:slug, ["Standalone Title"]).and_return("latest_slug")
            allow(instance).to receive(:generate_slug).with(:slug, "Newly Dirty"       ).and_return("newly_dirty")
          end

          context "unsaved draft" do
            let(:instance) { build(:tiny_standalone_post) }

            it "sets slug automatically" do
              expect(instance).to receive(:slugify).with(:slug, ["Standalone Title"])

              instance.send(:handle_slug)

              expect(instance.slug       ).to eq("latest_slug")
              expect(instance.dirty_slug?).to eq(false)
            end
          end

          context "saved draft" do
            let(:instance) { create(:tiny_standalone_post, :draft) }

            context "clean" do
              it "resets slug" do
                expect(instance).to receive(:slugify).with(:slug, ["Standalone Title"])

                instance.send(:handle_slug)

                expect(instance.slug       ).to eq("latest_slug")
                expect(instance.dirty_slug?).to eq(false)
              end
            end

            context "newly dirty" do
              it "slugifies dirty value and sets dirty flag" do
                expect(instance).to receive(:slugify).with(:slug, "Newly Dirty")

                instance.slug = "Newly Dirty"

                instance.send(:handle_slug)

                expect(instance.slug       ).to eq("newly_dirty")
                expect(instance.dirty_slug?).to eq(true)
              end
            end

            context "already dirty" do
              before(:each) do
                instance.update_columns(slug: "already_dirty", dirty_slug: true)
              end

              it "does nothing if no change" do
                instance.send(:handle_slug)

                expect(instance.slug       ).to eq("already_dirty")
                expect(instance.dirty_slug?).to eq(true)
              end

              it "slugifies new value if new value is dirty" do
                expect(instance).to receive(:slugify).with(:slug, "Newly Dirty")

                instance.slug = "Newly Dirty"

                instance.send(:handle_slug)

                expect(instance.slug       ).to eq("newly_dirty")
                expect(instance.dirty_slug?).to eq(true)
              end

              it "resets slug and sets dirty to false if new value is blank" do
                expect(instance).to receive(:slugify).with(:slug, ["Standalone Title"])

                instance.slug = ""

                instance.send(:handle_slug)

                expect(instance.slug       ).to eq("latest_slug")
                expect(instance.dirty_slug?).to eq(false)
              end
            end
          end

          context "saved published" do
            let(:instance) { create(:tiny_standalone_post, :published) }

            it "does nothing if value has not changed" do
              expect(instance).to_not receive(:slugify)

              previous = instance.slug

              instance.send(:handle_slug)

              expect(instance.slug       ).to eq(previous)
              expect(instance.dirty_slug?).to eq(false)
              expect(instance.errors.details[:slug].first).to eq(nil)
            end

            it "does nothing if value has not changed" do
              expect(instance).to_not receive(:slugify)

              instance.slug = "this is not allowed"

              instance.send(:handle_slug)

              expect(instance.slug       ).to eq("this is not allowed")
              expect(instance.dirty_slug?).to eq(false)
              expect(instance.errors.details[:slug].first).to eq({ error: :locked })
            end
          end
        end
      end

      context "custom validators" do
        describe "#validate_work_and_title" do
          describe "with just work" do
            subject { build(:post, work_id: create(:minimal_work).id) }

            specify "ok" do
              subject.send(:validate_work_and_title)

              expect(subject.errors.details[:base]).to eq([])
            end
          end

          describe "with just title" do
            subject { build(:post, title: "") }

            specify "ok" do
              subject.send(:validate_work_and_title)

              expect(subject.errors.details[:base]).to eq([])
            end
          end

          describe "with neither" do
            subject { build(:post) }

            specify "errors" do
              subject.send(:validate_work_and_title)

              expect(subject.errors.details[:base].first[:error]).to eq(:needs_work_or_title)
            end
          end

          describe "with both" do
            subject { build(:post, title: "title", work_id: create(:minimal_work).id) }

            specify "errors" do
              subject.send(:validate_work_and_title)

              expect(subject.errors.details[:base].first[:error]).to eq(:has_work_and_title)
            end
          end

          describe "saved review" do
            subject { create(:song_review) }

            it "ensures work and no title" do
              subject.work_id = ""
              subject.title   = "title"

              subject.send(:validate_work_and_title)

              expect(subject.errors.details[:work_id].first).to eq({ error: :blank   })
              expect(subject.errors.details[:title  ].first).to eq({ error: :present })
            end
          end

          describe "saved standalone" do
            subject { create(:standalone_post) }

            it "ensures title and no work" do
              subject.title   = ""
              subject.work_id = create(:song).id

              subject.send(:validate_work_and_title)

              expect(subject.errors.details[:title  ].first).to eq({ error: :blank   })
              expect(subject.errors.details[:work_id].first).to eq({ error: :present })
            end
          end
        end
      end

      describe "aasm" do
        describe "guards" do
          describe "#can_publish?" do
            subject { build(:standalone_post) }

            specify "true if saved, valid and has slug & body" do
              subject.save

              expect(subject.send(:can_publish?)).to eq(true)
            end

            specify "false unless saved" do
              subject.slug = "foo_bar_bat"

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify "false unless draft" do
              subject.save
              subject.publish!

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify "false unless valid" do
              subject.save
              subject.title = nil

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify "false unless slug" do
              subject.save
              subject.slug = nil

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify "false unless body" do
              subject.save
              subject.body = nil

              expect(subject.send(:can_publish?)).to eq(false)
            end
          end

          describe "#can_unpublish?" do
            specify { expect(create(:standalone_post, :published).send(:can_unpublish?)).to eq(true ) }
            specify { expect(create(:standalone_post, :draft    ).send(:can_unpublish?)).to eq(false) }
          end
        end

        context "callbacks" do
          describe "#prepare_to_publish" do
            it "sets published_at" do
              instance = create(:standalone_post, :draft)

              instance.send(:prepare_to_publish)

              expect(instance.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            end
          end

          describe "#prepare_to_unpublish" do
            it "removes published_at" do
              instance = create(:standalone_post, :published)

              instance.send(:prepare_to_unpublish)

              expect(instance.published_at).to eq(nil)
            end
          end
        end

        describe "#update_viewable_counts" do
          let(    :review) { create(:unity_album_review  ) }
          let(:standalone) { create(:tiny_standalone_post) }
          let(      :work) { double }
          let(  :creators) { [double, double] }

          it "updates counts for creators and works" do
            allow(review).to receive(    :work).and_return(work)
             allow( work).to receive(:creators).and_return(creators)

             allow(          work).to receive(:update_counts)
             allow(creators.first).to receive(:update_counts)
             allow( creators.last).to receive(:update_counts)

            expect(          work).to receive(:update_counts).once
            expect(creators.first).to receive(:update_counts).once
            expect( creators.last).to receive(:update_counts).once

            review.send(:update_viewable_counts)
          end

          it "does nothing for standalone" do
             allow_any_instance_of(Creator).to     receive(:update_counts)
             allow_any_instance_of(   Work).to     receive(:update_counts)

            expect_any_instance_of(Creator).to_not receive(:update_counts)
            expect_any_instance_of(   Work).to_not receive(:update_counts)

            standalone.send(:update_viewable_counts)
          end
        end
      end
    end
  end
end
