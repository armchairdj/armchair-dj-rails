# frozen_string_literal: true

RSpec.shared_examples "a_viewable_model" do
  context "included" do
    context "scope-related" do
      let!(    :draft) { create_minimal_instance(:with_draft_post    ) }
      let!(:scheduled) { create_minimal_instance(:with_scheduled_post) }
      let!(:published) { create_minimal_instance(:with_published_post) }

      let(:ids) { [draft, scheduled, published].map(&:id) }

      context "scopes" do
        describe "self#viewable" do
          subject { described_class.viewable.where(id: ids) }

          it { is_expected.to contain_exactly(published) }
        end

        describe "self#unviewable" do
          subject { described_class.unviewable.where(id: ids) }

          it { is_expected.to contain_exactly(draft, scheduled) }
        end
      end

      context "booleans" do
        describe "#viewable?" do
          specify { expect(    draft.viewable?).to eq(false) }
          specify { expect(scheduled.viewable?).to eq(false) }
          specify { expect(published.viewable?).to eq(true ) }
        end

        describe "#unviewable?" do
          specify { expect(    draft.unviewable?).to eq(true ) }
          specify { expect(scheduled.unviewable?).to eq(true ) }
          specify { expect(published.unviewable?).to eq(false) }
        end
      end
    end

    context "hooks" do
      describe "before_save" do
        subject { build_minimal_instance(:with_draft_post) }

        it "calls #refresh_viewable" do
           allow(subject).to receive(:refresh_viewable).and_call_original
          expect(subject).to receive(:refresh_viewable)

          subject.save
        end

        context "callbacks" do
          describe "#refresh_viewable (invoked via save)" do
            describe "becoming viewable" do
              subject { create_minimal_instance(:with_draft_post) }

              specify do
                allow(subject).to receive(:has_published_content?).and_return(true)

                expect(subject.viewable?).to eq(false)

                subject.save

                expect(subject.viewable?).to eq(true)
              end
            end

            describe "becoming unviewable" do
              subject { create_minimal_instance(:with_published_post) }

              specify do
                allow(subject).to receive(:has_published_content?).and_return(false)

                expect(subject.viewable?).to eq(true)

                subject.save

                expect(subject.viewable?).to eq(false)
              end
            end

            describe "already viewable" do
              subject { create_minimal_instance(:with_published_post) }

              specify do
                allow(subject).to receive(:has_published_content?).and_return(true)

                expect(subject.viewable?).to eq(true)

                subject.save

                expect(subject.viewable?).to eq(true)
              end
            end

            describe "still unviewable" do
              subject { create_minimal_instance(:with_draft_post) }

              specify do
                allow(subject).to receive(:has_published_content?).and_return(false)

                expect(subject.viewable?).to eq(false)

                subject.save

                expect(subject.viewable?).to eq(false)
              end
            end
          end
        end
      end
    end
  end

  context "instance" do
    subject { create_minimal_instance }

    describe "#update_viewable" do
      before(:each) do
        allow(subject).to receive(:save            ).and_call_original
        allow(subject).to receive(:refresh_viewable).and_call_original
      end

      describe "no change" do
        before(:each) do
          expect(subject).to     receive(:refresh_viewable)
          expect(subject).to_not receive(:save)
        end

        context "viewable" do
          subject { create_minimal_instance(:with_published_post) }

          specify { subject.update_viewable }
        end

        context "unviewable" do
          subject { create_minimal_instance(:with_draft_post) }

          specify { subject.update_viewable }
        end
      end

      describe "change" do
        before(:each) do
          expect(subject).to receive(:refresh_viewable)
          expect(subject).to receive(:save)
        end

        context "viewable" do
          before(:each) do
            allow(subject).to receive(:has_published_content?).and_return(false)
          end

          subject { create_minimal_instance(:with_published_post) }

          specify { subject.update_viewable }
        end

        context "unviewable" do
          before(:each) do
            allow(subject).to receive(:has_published_content?).and_return(true)
          end

          subject { create_minimal_instance(:with_draft_post) }

          specify { subject.update_viewable }
        end
      end
    end
  end
end
