require 'rails_helper'

RSpec.describe Work, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    it { should have_many(:contributions) }

    it { should have_many(:creators    ).through(:contributions) }
    it { should have_many(:contributors).through(:contributions) }

    it { should have_many(:posts) }
  end

  describe 'nested_attributes' do
    it { should accept_nested_attributes_for(:contributions) }

    describe 'reject_if' do
      it 'rejects contributions without a creator_id' do
        instance = build(:song, contributions_attributes: {
          '0' => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id),
          '1' => attributes_for(:contribution, role: :creator, creator_id: nil                 )
        })

        expect {
          instance.save
        }.to change {
          Contribution.count
        }.by(1)

        expect(instance.contributions.length).to eq(1)
      end
    end
  end

  describe 'enums' do
    describe "medium" do
      it { should define_enum_for(:medium) }

      it_behaves_like "an enumable model", [:medium]
    end
  end

  describe 'scopes' do
    describe 'alphabetical' do
      let!(:tki  ) { create(:album, title: 'The Kick Inside'  ) }
      let!(:lh   ) { create(:album, title: 'lionheart'        ) }
      let!(:nfe  ) { create(:album, title: 'Never for Ever'   ) }
      let!(:td   ) { create(:album, title: 'The Dreaming'     ) }
      let!(:hol  ) { create(:album, title: 'Hounds of Love'   ) }
      let!(:tsw  ) { create(:album, title: 'the sensual world') }
      let!(:trs  ) { create(:album, title: 'The Red Shoes'    ) }
      let!(:a    ) { create(:album, title: 'aerial'           ) }
      let!(:d    ) { create(:album, title: "Director's Cut"   ) }
      let!(:fifty) { create(:album, title: '50 Words for Snow') }

      specify { expect(described_class.alphabetical.to_a).to eq([
        fifty,
        a,
        d,
        hol,
        lh,
        nfe,
        td,
        tki,
        trs,
        tsw
      ]) }
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:medium) }
    it { should validate_presence_of(:title ) }

    context 'custom' do
      describe '#validate_contributions' do
        it 'confirms at least one creator' do
          instance = build(:work_for_contribution_factory)

          expect(instance.valid?).to eq(false)

          expect(instance.errors[:contributions][0]).to eq(
            I18n.t('activerecord.errors.models.work.attributes.contributions.missing')
          )
        end
      end
    end
  end

  describe 'hooks' do
    # Nothing so far.
  end

  describe 'class' do
    describe 'self#max_contributions' do
      specify { expect(described_class.max_contributions).to eq(10) }
    end

    describe 'self#alphabetical_with_creator' do
      let!(:madonna_ray_of_light             ) { create(:madonna_ray_of_light             ) }
      let!(:global_communications_76_14      ) { create(:global_communications_76_14      ) }
      let!(:kate_bush_directors_cut          ) { create(:kate_bush_directors_cut          ) }
      let!(:carl_craig_and_green_velvet_unity) { create(:carl_craig_and_green_velvet_unity) }
      let!(:kate_bush_hounds_of_love         ) { create(:kate_bush_hounds_of_love         ) }

      specify { expect(described_class.alphabetical_with_creator.to_a).to eq([
        carl_craig_and_green_velvet_unity,
        global_communications_76_14,
        kate_bush_directors_cut,
        kate_bush_hounds_of_love,
        madonna_ray_of_light
      ]) }
    end

    describe 'self#grouped_select_options_for_post' do
      specify 'first element of each sub-array is an optgroup heading' do
        expect(described_class.grouped_select_options_for_post.to_h.keys).to eq([
          "Songs",
          "Albums",
          "Movies",
          "TV",
          "Radio",
          "Podcast",
          "Books",
          "Comics",
          "Newspapers",
          "Magazines",
          "Art",
          "Game",
          "Software",
          "Hardware",
          "Product"
        ])
      end

      specify 'second element of each sub-array is a list of options' do
        described_class.grouped_select_options_for_post.to_h.values.each do |rel|
          expect(rel).to be_a_kind_of(ActiveRecord::Relation)
        end
      end
    end

    describe 'self#admin_scopes' do
      specify 'keys are short tab names' do
        expect(described_class.admin_scopes.keys).to eq([
          'All',
          'Song',
          'Album',
          'Movie',
          'TV',
          'Radio',
          'Pod',
          'Book',
          'Comic',
          'News',
          'Mag',
          'Art',
          'Game',
          'Software',
          'Hardware',
          'Product'
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

  describe 'instance' do
    describe '#prepare_contributions' do
      it 'prepares max for new' do
        instance = described_class.new

        expect(instance.contributions.length).to eq(0)

        instance.prepare_contributions

        expect(instance.contributions.length).to eq(10)
      end

      it 'prepares up to max for saved' do
        instance = create(:global_communications_76_14)

        expect(instance.contributions.length).to eq(3)

        instance.prepare_contributions

        expect(instance.contributions.length).to eq(10)
      end
    end

    describe '#title_with_creator' do
      specify {
        expect(create(:carl_craig_and_green_velvet_unity).title_with_creator).to eq(
          'Carl Craig & Green Velvet: Unity'
        )
      }

      specify {
        expect(create(:kate_bush_hounds_of_love).title_with_creator).to eq(
          'Kate Bush: Hounds of Love'
        )
      }
    end

    describe '#display_creator' do
      it 'displays mutiple creators alphabetically' do
        expect(create(:carl_craig_and_green_velvet_unity).display_creator).to eq(
          'Carl Craig & Green Velvet'
        )
      end

      it 'displays single creators' do
        expect(create(:kate_bush_hounds_of_love).display_creator).to eq(
          'Kate Bush'
        )
      end
    end

    context 'private' do
      context 'callbacks' do
        # Nothing so far.
      end
    end
  end
end
