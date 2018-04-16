require "rails_helper"

RSpec.describe Post, type: :model do
  context 'constants' do
    # Nothing so far.
  end

  context 'associations' do
    it { should belong_to(:work) }
  end

  context 'nested_attributes' do
    pending 'work'
  end

  context 'enums' do
    describe 'status' do
      it { should define_enum_for(:status) }

      it_behaves_like 'an enumable model', [:status]
    end
  end

  context 'scopes' do
    let!(        :draft_review) { create(:song_review,     :draft    ) }
    let!(    :published_review) { create(:song_review,     :published) }
    let!(    :draft_standalone) { create(:standalone_post, :draft    ) }
    let!(:published_standalone) { create(:standalone_post, :published) }

    describe 'for status' do
      describe 'draft' do
        specify { expect(described_class.draft).to match_array([
          draft_review,
          draft_standalone
        ]) }
      end

      describe 'published' do
        specify { expect(described_class.published).to match_array([
          published_review,
          published_standalone
        ]) }
      end
    end

    describe 'reverse_cron' do
      specify { expect(described_class.reverse_cron.to_a).to eq([
        draft_review,
        draft_standalone,
        published_standalone,
        published_review,
      ]) }
    end

    pending 'eager'
    pending 'for_admin'
    pending 'for_site'
  end

  context 'validations' do
    context 'custom' do
      it 'calls #ensure_work_or_title' do
         allow(subject).to receive(:ensure_work_or_title).and_call_original
        expect(subject).to receive(:ensure_work_or_title)

        subject.valid?
      end
    end

    context 'conditional' do
      subject { create(:minimal_post, :published) }

      context 'published' do
        it { should validate_presence_of(:body) }
        it { should validate_presence_of(:slug) }
        it { should validate_presence_of(:published_at) }
      end
    end
  end

  context 'hooks' do
    context 'before_create' do
      subject { build(:minimal_post) }

      it 'calls #set_slug' do
         allow(subject).to receive(:set_slug).and_call_original
        expect(subject).to receive(:set_slug)

        subject.save
      end
    end
  end

  context 'aasm' do
    let!(    :draft) { create(:standalone_post            ) }
    let!(:published) { create(:standalone_post, :published) }

    describe 'states' do
      specify { expect( Post.new).to have_state(:draft    ) }
      specify { expect(    draft).to have_state(:draft    ) }
      specify { expect(published).to have_state(:published) }
    end

    describe 'booleans' do
      before(:each) do
        allow(    draft).to receive(:can_publish?  ).and_return(true)
        allow(    draft).to receive(:can_unpublish?).and_return(false)
        allow(published).to receive(:can_publish?  ).and_return(false)
        allow(published).to receive(:can_unpublish?).and_return(true)
      end

      describe 'may_publish?' do
        specify 'on published' do
          expect(published).to_not receive(:can_publish?)

          expect(published.may_publish?).to eq(false)
        end

        specify 'on draft' do
          expect(draft).to receive(:can_publish?)

          expect(draft.may_publish?).to eq(true)
        end
      end

      describe 'may_unpublish?' do
        specify 'on draft' do
          expect(draft).to_not receive(:can_unpublish?)

          expect(draft.may_unpublish?).to eq(false)
        end

        specify 'on published' do
          expect(published).to receive(:can_unpublish?)

          expect(published.may_unpublish?).to eq(true)
        end
      end
    end

    describe 'transitions' do
      describe 'publish' do
        specify { expect(    draft).to     allow_transition_to(:published) }
        specify { expect(published).to_not allow_transition_to(:published) }
      end

      describe 'unpublish' do
        specify { expect(published).to     allow_transition_to(:draft) }
        specify { expect(    draft).to_not allow_transition_to(:draft) }
      end
    end

    describe 'events' do
      describe 'publish' do
        describe 'callbacks' do
          describe 'before' do
            it 'calls #prepare_to_publish' do
               allow(draft).to receive(:prepare_to_publish).and_call_original
              expect(draft).to receive(:prepare_to_publish)

              expect(draft.publish!).to eq(true)
            end
          end

          describe 'guards' do
            specify 'calls #can_publish?' do
               allow(draft).to receive(:can_publish?).and_call_original
              expect(draft).to receive(:can_publish?)

              expect(draft.publish!).to eq(true)
            end
          end

          describe 'after' do
            it 'calls #update_viewable_counts' do
               allow(draft).to receive(:update_viewable_counts).and_call_original
              expect(draft).to receive(:update_viewable_counts)

              expect(draft.publish!).to eq(true)
            end
          end
        end
      end

      describe 'unpublish' do
        describe 'callbacks' do
          describe 'before' do
            it 'calls #prepare_to_unpublish' do
               allow(published).to receive(:prepare_to_unpublish).and_call_original
              expect(published).to receive(:prepare_to_unpublish)

              expect(published.unpublish!).to eq(true)
            end
          end

          describe 'guards' do
            specify 'calls #can_unpublish?' do
               allow(published).to receive(:can_unpublish?).and_call_original
              expect(published).to receive(:can_unpublish?)

              expect(published.unpublish!).to eq(true)
            end
          end

          describe 'after' do
            it 'calls #update_viewable_counts' do
               allow(published).to receive(:update_viewable_counts).and_call_original
              expect(published).to receive(:update_viewable_counts)

              expect(published.unpublish!).to eq(true)
            end
          end
        end
      end
    end

    describe 'scopes' do
      specify { expect(described_class.draft    ).to be_a_kind_of(ActiveRecord::Relation) }
      specify { expect(described_class.published).to be_a_kind_of(ActiveRecord::Relation) }
    end

    describe 'methods' do
      specify { expect(draft.respond_to?(    :draft?)).to eq(true) }
      specify { expect(draft.respond_to?(:published?)).to eq(true) }
    end
  end

  context 'class' do
    describe 'self#admin_scopes' do
      specify 'keys are short tab names' do
        expect(described_class.admin_scopes.keys).to eq([
          'Draft',
          'Published',
          'All',
        ])
      end

      specify 'values are symbols of scopes' do
        described_class.admin_scopes.values.each do |sym|
          expect(sym).to be_a_kind_of(Symbol)

          expect(described_class.respond_to?(sym)).to eq(true)
        end
      end
    end

    describe 'self#default_admin_scope' do
      specify { expect(described_class.default_admin_scope).to eq(:draft) }
    end
  end

  context 'instance' do
    context 'booleans' do
      let(:unsaved_standalone) {  build(:standalone_post) }
      let(  :saved_standalone) { create(:standalone_post) }
      let(    :unsaved_review) {  build(:song_review    ) }
      let(      :saved_review) { create(:song_review    ) }

      describe '#standalone?' do
        specify { expect(unsaved_standalone.standalone?).to eq(true ) }
        specify { expect(  saved_standalone.standalone?).to eq(true ) }
        specify { expect(    unsaved_review.standalone?).to eq(false) }
        specify { expect(      saved_review.standalone?).to eq(false) }
      end

      describe '#review?' do
        specify { expect(unsaved_standalone.review?).to eq(false) }
        specify { expect(  saved_standalone.review?).to eq(false) }
        specify { expect(    unsaved_review.review?).to eq(true ) }
        specify { expect(      saved_review.review?).to eq(true ) }
      end
    end

    describe '#one_line_title' do

    end

    describe '#simulate_validation_for_publishing' do

    end

    describe 'private' do
      describe 'callbacks' do
        describe '#set_slug' do

        end

        describe '#sluggable_parts' do

        end
      end

      describe 'custom validators' do
        describe '#ensure_work_or_title' do

        end
      end

      describe 'aasm' do
        describe 'guards' do
          describe '#can_publish?' do
            subject { build(:standalone_post) }

            specify 'true if saved, valid and has slug & body' do
              subject.save

              expect(subject.send(:can_publish?)).to eq(true)
            end

            specify 'false unless saved' do
              subject.slug = 'foo_bar_bat'

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify 'false unless draft' do
              subject.save
              subject.publish!

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify 'false unless valid' do
              subject.save
              subject.title = nil

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify 'false unless slug' do
              subject.save
              subject.slug = nil

              expect(subject.send(:can_publish?)).to eq(false)
            end

            specify 'false unless body' do
              subject.save
              subject.body = nil

              expect(subject.send(:can_publish?)).to eq(false)
            end
          end

          describe '#can_unpublish?' do
            specify { expect(create(:standalone_post, :published).send(:can_unpublish?)).to eq(true ) }
            specify { expect(create(:standalone_post, :draft    ).send(:can_unpublish?)).to eq(false) }
          end
        end

        describe 'callbacks' do
          describe '#prepare_to_publish' do

          end

          describe '#prepare_to_unpublish' do

          end
        end

        describe '#update_viewable_counts' do

        end
      end
    end
  end

  context 'concerns' do
    it_behaves_like 'a sluggable model', :slug
  end
end
