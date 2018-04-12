require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    it { should belong_to(:work) }
  end

  describe 'nested_attributes' do
    # Nothing so far.
  end

  describe 'enums' do
    # Nothing so far.
  end

  describe 'scopes' do
    pending 'reverse_cron'
    pending 'for_admin'
    pending 'for_site'
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }

    pending '#ensure_work_or_title'
  end

  describe 'hooks' do
    # Nothing so far.
  end

  describe 'class' do
    # Nothing so far.
  end

  describe 'instance' do
    pending '#one_line_title'

    describe 'private' do
      describe 'callbacks' do
        # Nothing so far.
      end
    end
  end
end
