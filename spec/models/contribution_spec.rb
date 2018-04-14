require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  context 'plugins' do
    # Nothing so far.
  end

  context 'associations' do
    it { should belong_to(:creator) }
    it { should belong_to(:work   ) }
  end

  context 'nested_attributes' do
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

  context 'enums' do
    describe "role" do
      it { should define_enum_for(:role) }

      it_behaves_like 'an enumable model', [:role]
    end
  end

  context 'scopes' do
    # Nothing so far.
  end

  context 'validations' do
    it { should validate_presence_of(:role   ) }
    it { should validate_presence_of(:work   ) }
    it { should validate_presence_of(:creator) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role) }
  end

  context 'hooks' do
    # Nothing so far.
  end

  context 'class' do
    # Nothing so far.
  end

  context 'instance' do
    describe 'private' do
      describe 'callbacks' do
        # Nothing so far.
      end
    end
  end

  context 'concerns' do
    # Nothing so far.
  end
end
