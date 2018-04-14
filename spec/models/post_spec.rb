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
    it { should validate_presence_of(:body) }

    context 'custom' do
      pending 'calls #ensure_work_or_title'
    end

    context 'conditional' do
      context 'published' do
        pending 'slug presence'
        pending 'published_at presence'
      end
    end
  end

  context 'hooks' do
    # Nothing so far.
  end

  context 'aasm' do
    let!(    :draft) { build(:standalone_post             ) }
    let!(:published) { create(:standalone_post, :published) }

    describe 'initial' do
    end

    describe 'states' do
      describe 'exist' do
        specify { expect(    draft).to have_state(:draft    ) }
        specify { expect(published).to have_state(:published) }
      end
    end

    describe 'transitions' do
      describe 'publish' do
        specify { expect(    draft).to     allow_transition_to(:published) }
        specify { expect(published).to_not allow_transition_to(:published) }
      end
    end

    describe 'callbacks' do
      describe 'publish' do
        it 'calls prepare_to_publish' do
           allow(draft).to receive(:prepare_to_publish).and_call_original
          expect(draft).to receive(:prepare_to_publish)

          draft.publish!
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
    describe 'self#slugify' do
      pending 'special characters'
      pending 'non-ASCII characters'
      pending 'whitespace'
      pending '&'
    end

    describe 'self#admin_scopes' do
      specify 'keys are short tab names' do
        expect(described_class.admin_scopes.keys).to eq([
          'All',
          'Draft',
          'Published',
        ])
      end

      specify 'values are symbols of scopes' do
        described_class.admin_scopes.values.each do |sym|
          expect(sym).to be_a_kind_of(Symbol)

          expect(described_class.respond_to?(sym)).to eq(true)
        end
      end
    end
  end

  context 'instance' do
    pending '#one_line_title'

    describe 'private' do
      describe 'callbacks' do
        pending '#ensure_work_or_title'
        pending '#prepare_to_publish'
        pending '#set_published_at'
        pending '#set_slug'
        pending '#sluggable_parts'
      end
    end
  end

  context 'concerns' do
    it_behaves_like 'a sluggable model', :slug
  end
end
