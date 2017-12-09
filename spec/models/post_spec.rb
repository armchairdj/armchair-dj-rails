require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    it { should belong_to(:postable) }
  end

  describe 'enums' do
    # Nothing so far.
  end

  describe 'scopes' do
    pending 'reverse_cron'
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'hooks' do
    # Nothing so far.
  end

  describe 'instance' do
    pending 'postable_gid'
    pending 'postable_gid='
  end

  describe 'class' do
    # Nothing so far.
  end
end
