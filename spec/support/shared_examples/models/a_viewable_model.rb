# frozen_string_literal: true

RSpec.shared_examples "a_viewable_model" do
  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "Viewable",
          "Non-Viewable",
        ])
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:all) }
    end
  end

  context "included" do
    context "hooks" do
      describe "before_save" do
        subject { build_minimal_instance }

        it "calls #refresh_counts" do
           allow(subject).to receive(:refresh_counts).and_call_original
          expect(subject).to receive(:refresh_counts)

          subject.save
        end

        context "callbacks" do
          describe "#refresh_counts" do
            let(:instance_with_accurate_counts) {
              create_minimal_instance(:with_one_of_each_post_status)
            }

            let(:instance_with_inaccurate_counts) {
              instance = instance_with_accurate_counts
              instance.update_columns(viewable_post_count: 0, non_viewable_post_count: 0)
              instance
            }

            before(:each) do
               allow(subject).to     receive(:save).and_call_original
              expect(subject).to_not receive(:save)
            end

            describe "with changes" do
              subject { instance_with_inaccurate_counts }

              it "caches counts without saving" do
                expect(subject.viewable_post_count    ).to eq(0)
                expect(subject.non_viewable_post_count).to eq(0)

                expect(subject.send(:refresh_counts)).to eq(true)

                expect(subject.viewable_post_count    ).to eq(1)
                expect(subject.non_viewable_post_count).to eq(2)
              end
            end

            describe "without changes" do
              subject { instance_with_accurate_counts }

              it "does nothing" do
                expect(subject.viewable_post_count    ).to eq(1)
                expect(subject.non_viewable_post_count).to eq(2)

                expect(subject.send(:refresh_counts)).to eq(false)

                expect(subject.viewable_post_count    ).to eq(1)
                expect(subject.non_viewable_post_count).to eq(2)
              end
            end
          end
        end
      end
    end

    context "scope-related" do
      let!(    :draft_instance) { create_minimal_instance(:with_draft_post    ) }
      let!(:scheduled_instance) { create_minimal_instance(:with_scheduled_post) }
      let!(:published_instance) { create_minimal_instance(:with_published_post     ) }

      context "scopes" do
        describe "self#viewable" do
          specify { expect(described_class.viewable.to_a).to eq([
            published_instance
          ]) }
        end

        describe "self#non_viewable" do
          specify { expect(described_class.non_viewable.to_a).to eq([
            draft_instance,
            scheduled_instance
          ]) }
        end
      end

      context "booleans" do
        describe "#viewable?" do
          specify { expect(    draft_instance.viewable?).to eq(false) }
          specify { expect(scheduled_instance.viewable?).to eq(false) }
          specify { expect(published_instance.viewable?).to eq(true ) }
        end

        describe "#non_viewable?" do
          specify { expect(    draft_instance.non_viewable?).to eq(true ) }
          specify { expect(scheduled_instance.non_viewable?).to eq(true ) }
          specify { expect(published_instance.non_viewable?).to eq(false) }
        end
      end

      context "scoped associations" do
        describe "#viewable_posts" do
          specify { expect(    draft_instance.viewable_posts).to have(0).items }
          specify { expect(scheduled_instance.viewable_posts).to have(0).items }
          specify { expect(published_instance.viewable_posts).to have(1).items }
        end

        describe "#non_viewable_posts" do
          specify { expect(    draft_instance.non_viewable_posts).to have(1).items }
          specify { expect(scheduled_instance.non_viewable_posts).to have(1).items }
          specify { expect(published_instance.non_viewable_posts).to have(0).items }
        end

        describe "#viewable_works" do
          specify { expect(    draft_instance.viewable_works).to have(0).items }
          specify { expect(scheduled_instance.viewable_works).to have(0).items }
          specify { expect(published_instance.viewable_works).to have(1).items }
        end

        describe "#non_viewable_works" do
          specify { expect(    draft_instance.non_viewable_works).to have(1).items }
          specify { expect(scheduled_instance.non_viewable_works).to have(1).items }
          specify { expect(published_instance.non_viewable_works).to have(0).items }
        end
      end
    end
  end

  context "instance" do
    describe "#update_counts" do
      let(:instance_with_accurate_counts) {
        create_minimal_instance(:with_one_of_each_post_status)
      }

      let(:instance_with_inaccurate_counts) {
        instance = instance_with_accurate_counts
        instance.update_columns(viewable_post_count: 0, non_viewable_post_count: 0)
        instance
      }

      before(:each) do
         allow(subject).to receive(:save          ).and_call_original
         allow(subject).to receive(:refresh_counts).and_call_original
        expect(subject).to receive(:refresh_counts)
      end

      describe "with changes" do
        subject { instance_with_inaccurate_counts }

        it "caches counts and saves" do
          expect(subject.viewable_post_count    ).to eq(0)
          expect(subject.non_viewable_post_count).to eq(0)

          expect(subject).to receive(:save)

          expect(subject.update_counts).to eq(true)

          subject.reload

          expect(subject.viewable_post_count    ).to eq(1)
          expect(subject.non_viewable_post_count).to eq(2)
        end
      end

      describe "without changes" do
        subject { instance_with_accurate_counts }

        it "does nothing" do
          expect(subject.viewable_post_count    ).to eq(1)
          expect(subject.non_viewable_post_count).to eq(2)

          expect(subject).to_not receive(:save)

          expect(subject.update_counts).to eq(false)

          subject.reload

          expect(subject.viewable_post_count    ).to eq(1)
          expect(subject.non_viewable_post_count).to eq(2)
        end
      end
    end
  end
end
