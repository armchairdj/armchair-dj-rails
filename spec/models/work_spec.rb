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

    describe "reject_if" do
      it "rejects contributions without a creator_id" do
        instance = build(:song, contributions_attributes: {
          "0" => attributes_for(:contribution, role: :creator, creator_id: create(:musician).id),
          "1" => attributes_for(:contribution, role: :creator, creator_id: nil                 )
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
    it { should define_enum_for(:medium) }
  end

  describe 'scopes' do
    describe 'alphabetical' do
      let!(:tki  ) { create(:album, title: "The Kick Inside"  ) }
      let!(:lh   ) { create(:album, title: "lionheart"        ) }
      let!(:nfe  ) { create(:album, title: "Never for Ever"   ) }
      let!(:td   ) { create(:album, title: "The Dreaming"     ) }
      let!(:hol  ) { create(:album, title: "Hounds of Love"   ) }
      let!(:tsw  ) { create(:album, title: "the sensual world") }
      let!(:trs  ) { create(:album, title: "The Red Shoes"    ) }
      let!(:a    ) { create(:album, title: "aerial"           ) }
      let!(:d    ) { create(:album, title: "Director's Cut"   ) }
      let!(:fifty) { create(:album, title: "50 Words for Snow") }

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
      pending '#validate_contributions'
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
      let!(:kate_bush_directors_cut          ) { create(:kate_bush_directors_cut          ) }
      let!(:carl_craig_and_green_velvet_unity) { create(:carl_craig_and_green_velvet_unity) }
      let!(:kate_bush_hounds_of_love         ) { create(:kate_bush_hounds_of_love         ) }
      let!(:global_communications_76_14      ) { create(:global_communications_76_14      ) }

      specify { expect(described_class.alphabetical_with_creator.to_a).to eq([
        carl_craig_and_green_velvet_unity,
        global_communications_76_14,
        kate_bush_directors_cut,
        kate_bush_hounds_of_love,
        madonna_ray_of_light
      ]) }
    end

    describe 'self#grouped_select_options_for_post' do

    end

    describe 'self#admin_scopes' do

    end
  end

  describe 'instance' do
    pending '#prepare_contributions'
    pending '#title_with_creator'
    pending '#display_creator'

    context 'private' do
      context 'nested_attributes' do
        pending '#reject_blank_contributions'
      end

      context 'validation' do
        pending '#validate_contributions'
      end

      context 'callbacks' do
        # Nothing so far.
      end
    end
  end
end
