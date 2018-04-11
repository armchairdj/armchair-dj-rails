require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    it { should belong_to(:creator) }
    it { should belong_to(:work   ) }
  end

  describe 'nested_attributes' do
    it { should accept_nested_attributes_for(:creator) }

    describe "reject_if" do
      it "rejects with blank creator name" do
        instance = build(:contribution_with_new_creator, creator_attributes: {
          "0" => { "name" => "" }
        })

        expect {
          instance.save
        }.to_not change {
          Contribution.count
        }

        expect {
          instance.save
        }.to_not change {
          Creator.count
        }

        expect(instance.valid?).to eq(false)
      end
    end
  end

  describe 'enums' do
    it { should define_enum_for(:role) }

    it_behaves_like "an enumable model", [:role]
  end

  describe 'scopes' do
    # Nothing so far.
  end

  describe 'validations' do
    it { should validate_presence_of(:role   ) }
    it { should validate_presence_of(:work   ) }
    it { should validate_presence_of(:creator) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role) }
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
