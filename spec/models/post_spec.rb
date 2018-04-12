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

    it { should validate_uniqueness_of(:slug) }

    context 'custom' do
      pending 'calls #ensure_work_or_title'
    end

    context 'conditional' do
      pending 'slug presence'
    end
  end

  describe 'hooks' do
    describe 'after_initialize' do
      pending 'calls #ensure_slug'
    end
  end

  describe 'class' do
    pending 'self#slugify'
  end

  describe 'instance' do
    pending '#one_line_title'
    describe '#published?'

    describe 'private' do
      describe 'callbacks' do
        pending '#ensure_work_or_title'
        pending '#ensure_slug'
        pending '#generate_slug'
      end
    end
  end
end
