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
    pending 'alphabetical'
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
