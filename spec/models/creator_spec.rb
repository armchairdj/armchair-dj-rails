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
      it { should have_many(:works) }
      it { should have_many(:works) }
    end
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

  describe 'instance' do
    # Nothing so far.
  end

  describe 'class' do
    # Nothing so far.
  end
end
