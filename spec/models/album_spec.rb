require 'rails_helper'

RSpec.describe Album, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    it { should belong_to(:artist) }
    it { should have_many(:posts) }
  end

  describe 'enums' do
    # Nothing so far.
  end

  describe 'scopes' do
    pending 'alphabetical'
    pending 'alphabetical_by_artist'
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'hooks' do
    # Nothing so far.
  end

  describe 'instance' do

  end

  describe 'class' do
    # Nothing so far.
  end
end
