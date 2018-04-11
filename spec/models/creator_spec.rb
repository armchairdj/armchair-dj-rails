require 'rails_helper'

RSpec.describe Creator, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    describe 'associations' do
      it { should have_many(:contributions) }

      it { should have_many(:works   ).through(:contributions) }
      it { should have_many(:contributed_works).through(:contributions) }

      it { should have_many(:posts).through(:works) }
    end
  end

  describe 'nested_attributes' do
    # Nothing so far.
  end

  describe 'enums' do
    # Nothing so far.
  end

  describe 'scopes' do
    describe 'alphabetical' do
      let!(:zorro  ) { create(:creator, name: "Zorro the Gay Blade") }
      let!(:amy_1  ) { create(:creator, name: "amy winehouse") }
      let!(:kate   ) { create(:creator, name: "Kate Bush") }
      let!(:amy_2  ) { create(:creator, name: "Amy Wino") }
      let!(:anthony) { create(:creator, name: "Anthony Childs") }
      let!(:zero   ) { create(:creator, name: "0773") }

      specify { expect(described_class.alphabetical.to_a).to eq([
        zero,
        amy_1,
        amy_2,
        anthony,
        kate,
        zorro
      ]) }
    end

    describe 'with_counts' do
      let!(:artist) { create(:musician) }
      let!(:song  ) { create(:song, contributions_attributes: {
          "0" => attributes_for(:contribution, role: :creator, creator_id: artist.id)
      } ) }
      let!(:album ) { create(:album, contributions_attributes: {
          "0" => attributes_for(:contribution, role: :creator, creator_id: artist.id)
      } ) }
      let!(:review) { create(:song_review, work_id:    song.id  ) }

      it "counts posts and works" do
        actual = described_class.with_counts[0]

        expect(actual.work_count).to eq(2)
        expect(actual.post_count).to eq(1)
      end
    end
  end

  describe 'validations' do
    describe 'name' do
      it { should validate_presence_of(:name) }
    end
  end

  describe 'hooks' do
    # Nothing so far.
  end

  describe 'class' do
    # Nothing so far.
  end

  describe 'instance' do
    describe 'private' do
      describe 'callbacks' do
        # Nothing so far.
      end
    end
  end
end
