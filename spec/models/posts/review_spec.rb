# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
      let!(     :draft) { create_minimal_instance(:draft    ) }
      let!( :scheduled) { create_minimal_instance(:scheduled) }
      let!( :published) { create_minimal_instance(:published) }
      let!(       :ids) { [draft, scheduled, published].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

    context "basics" do
      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:author, :tags, :work, :medium, :creators) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to contain_exactly(draft, scheduled, published) }

        it { is_expected.to eager_load(:author, :tags, :work, :medium, :creators) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq [published] }

        it { is_expected.to eager_load(:author, :tags, :work, :medium, :creators) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:work) }

    it { is_expected.to have_one(:medium       ).through(:work) }
    it { is_expected.to have_many(:creators    ).through(:work) }
    it { is_expected.to have_many(:contributors).through(:work) }
    it { is_expected.to have_many(:aspects     ).through(:work) }
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
      it { is_expected.to accept_nested_attributes_for(:work).allow_destroy(false) }

      describe "reject_if" do
        subject { build(:review, work_attributes: { "0" => { "title" => "" } }) }

        it "rejects works with blank titles" do
          expect { subject.save }.to_not change { Work.count }

          expect(subject.work).to eq(nil)
        end
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#type" do
      let(:instance) { create(:song_review) }

      specify { expect(instance.type              ).to eq("Song Review" ) }
      specify { expect(instance.type(plural: true)).to eq("Song Reviews") }
    end

    describe "#cascade_viewable" do
      subject { create_minimal_instance }

      before(:each) do
         allow(subject.work).to receive(:cascade_viewable)
        expect(subject.work).to receive(:cascade_viewable)
      end

      it "updates viewable for descendents" do
        subject.cascade_viewable
      end
    end

    describe "#prepare_work_for_editing" do
      context "saved" do
        subject { create(:minimal_review) }

        let!(      :work_id) { subject.work_id }
        let!(:other_work_id) { create(:minimal_song).id }

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
        subject { build(:minimal_review) }

        let!(      :work_id) { subject.work_id }
        let!(:other_work_id) { create(:minimal_song).id }

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

    describe "#sluggable_parts" do
      let(:review) { create(:hounds_of_love_album_review) }
      let(:collab) { create(:unity_album_review         ) }

      specify "for review" do
        expect(review.sluggable_parts) .to eq(["Albums", "Kate Bush", "Hounds of Love", nil])
      end

      specify "for review of work with subtitle" do
        review.work.subtitle = "Remastered"

        expect(review.sluggable_parts) .to eq(["Albums", "Kate Bush", "Hounds of Love", "Remastered"])
      end

      specify "for review of collaborative work" do
        expect(collab.sluggable_parts).to eq(["Albums", "Carl Craig and Green Velvet", "Unity", nil])
      end
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq(instance.work.alpha_parts) }
    end
  end
end
