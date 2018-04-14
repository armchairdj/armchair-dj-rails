RSpec.shared_examples 'a viewable model' do
  let!(    :viewable_instance) { create_minimal_instance(:with_published_post) }
  let!(:non_viewable_instance) { create_minimal_instance(:with_draft_post    ) }

  context 'included' do
    context 'hooks' do
      describe 'before_save' do
        subject { build_minimal_instance }

        it 'calls #update_counts' do
           allow(subject).to receive(:update_counts).and_call_original
          expect(subject).to receive(:update_counts)

          subject.save
        end
      end
    end

    context 'scopes' do
      describe 'viewable' do
        specify { expect(described_class.viewable.to_a    ).to eq([viewable_instance    ]) }
      end

      describe 'non_viewable' do
        specify { expect(described_class.non_viewable.to_a).to eq([non_viewable_instance]) }
      end
    end
  end

  context 'class' do
    describe 'self#admin_scopes' do
      specify 'keys are short tab names' do
        expect(described_class.admin_scopes.keys).to eq([
          'Viewable',
          'Non-Viewable',
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
      specify { expect(described_class.default_admin_scope).to eq(:viewable) }
    end
  end

  context 'instance' do
    describe '#viewable?' do
      specify { expect(    viewable_instance.viewable?).to eq(true ) }
      specify { expect(non_viewable_instance.viewable?).to eq(false) }
    end

    describe '#non_viewable?' do
      specify { expect(    viewable_instance.non_viewable?).to eq(false) }
      specify { expect(non_viewable_instance.non_viewable?).to eq(true ) }
    end

    describe '#viewable_posts' do
      specify { expect(    viewable_instance.viewable_posts.length).to eq(1) }
      specify { expect(non_viewable_instance.viewable_posts.length).to eq(0) }
    end

    describe '#non_viewable_posts' do
      specify { expect(    viewable_instance.non_viewable_posts.length).to eq(0) }
      specify { expect(non_viewable_instance.non_viewable_posts.length).to eq(1) }
    end

    describe '#viewable_works' do
      specify { expect(    viewable_instance.viewable_works.length).to eq(1) }
      specify { expect(non_viewable_instance.viewable_works.length).to eq(0) }
    end

    describe '#non_viewable_works' do
      specify { expect(    viewable_instance.non_viewable_works.length).to eq(0) }
      specify { expect(non_viewable_instance.non_viewable_works.length).to eq(1) }
    end

    context 'private' do
      describe 'callbacks' do
        describe '#update_counts' do
          subject { create_minimal_instance(:with_published_post_and_draft_post) }

          it 'caches counts' do
            subject.update!(viewable_post_count: 0, non_viewable_post_count: 0)

            expect(subject.viewable_post_count    ).to eq(0)
            expect(subject.non_viewable_post_count).to eq(0)

            subject.send(:update_counts)

            expect(subject.non_viewable_post_count).to eq(1)
            expect(subject.viewable_post_count    ).to eq(1)
          end
        end
      end
    end
  end
end