require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  context 'plugins' do
    # Nothing so far.
  end

  context 'associations' do
    it { should belong_to(:work) }
  end

  context 'nested_attributes' do
    # Nothing so far.
  end

  context 'enums' do
    describe 'status' do
      it { should define_enum_for(:status) }

      it_behaves_like 'an enumable model', [:status]
    end
  end

  context 'scopes' do
    pending 'draft'
    pending 'published'

    pending 'reverse_cron'

    pending 'eager'

    pending 'for_admin'
    pending 'for_site'
  end

  context 'validations' do
    context 'custom' do
      pending 'calls #ensure_work_or_title'
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
      pending 'set_slug'
    end
  end

  context 'aasm' do
    let!(    :draft) { create(:standalone_post            ) }
    let!(:published) { create(:standalone_post, :published) }

    describe 'initial' do
      specify { expect(Post.new).to have_state(:draft) }

    end

    describe 'states' do
      specify { expect(    draft).to have_state(:draft    ) }
      specify { expect(published).to have_state(:published) }
    end

    describe 'transitions' do
      describe 'publish' do
        specify { expect(    draft).to     allow_transition_to(:published) }
        specify { expect(published).to_not allow_transition_to(:published) }
      end
    end

    describe 'events' do
      describe 'publish' do
        describe 'callbacks' do
          describe 'before' do
            it 'calls #set_published_at' do
               allow(draft).to receive(:set_published_at).and_call_original
              expect(draft).to receive(:set_published_at)

              expect(draft.publish!).to eq(true)
            end
          end

          describe 'after' do
            it 'calls #update_counts' do
               allow(draft).to receive(:update_counts).and_call_original
              expect(draft).to receive(:update_counts)

              expect(draft.publish!).to eq(true)
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
    pending '#one_line_title'
    pending '#can_publish?'

    describe 'private' do
      describe 'callbacks' do
        pending '#ensure_work_or_title'
        pending '#set_published_at'
        pending '#set_slug'
        pending '#sluggable_parts'
        pending '#update_counts'
      end
    end
  end

  context 'concerns' do
    it_behaves_like 'a sluggable model', :slug
  end
end
