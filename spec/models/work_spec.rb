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
    pending "contributions"
  end

  describe 'enums' do
    it { should define_enum_for(:medium).with({
      song:       100,
      album:      101,

      film:       200,
      tv_show:    201,

      book:       300,
      comic:      301,

      artwork:    400,

      software:   500
    }) }
  end

  describe 'scopes' do
    pending 'alphabetical'
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:medium) }

    context 'custom' do
      pending '#validate_contributions'
    end
  end

  describe 'hooks' do
    # Nothing so far.
  end

  describe 'class' do
    pending 'self#max_contributions'
    pending 'self#alphabetical_with_creator'
    pending 'self#grouped_select_options_for_post'
    pending 'self#admin_scopes'
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
