require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'constants' do
    # Nothing so far.
  end

  describe 'plugins' do
    # Nothing so far.
  end

  describe 'associations' do
    # Nothing so far.
  end

  describe 'nested_attributes' do
    # Nothing so far.
  end

  describe 'enums' do
    it { should define_enum_for(:role) }

    it_behaves_like "an enumable model", [:role]
  end

  describe 'scopes' do
    # Nothing so far.
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    skip { should validate_presence_of(:role) }
  end

  describe 'hooks' do
    describe 'before_validation' do
      before(:each) do
        allow_any_instance_of(User).to receive(:set_default_role)
      end

      it 'calls set_default_role on new instance' do
        user = build(:minimal_user)

        expect(user).to receive(:set_default_role)

        user.valid?
      end

      it 'does not call on saved instance' do
        user = create(:minimal_user)

        expect(user).not_to receive(:set_default_role)

        user.valid?
      end
    end
  end

  describe 'class' do
    # Nothing so far.
  end

  describe 'instance' do
    pending '#display_name'

    describe 'private' do
      describe 'callbacks' do
        describe '#set_default_role' do
          it "sets role to guest if no role" do
            user = build(:minimal_user, role: nil)

            user.send(:set_default_role)

            expect(user.role).to eq("guest")
          end

          it "does nothing if role is set" do
            user = build(:minimal_user, role: :admin)

            user.send(:set_default_role)

            expect(user.role).to eq("admin")
          end
        end
      end
    end
  end
end
