require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  context 'concerns' do
    it_behaves_like 'an errorable controller'
  end

  context 'methods' do
    context 'private' do
      describe '#determine_layout' do
        context 'public pages' do
          specify { expect(controller.send(:determine_layout)).to eq('public') }
        end

        context 'admin pages' do
          before(:each) do
            controller.instance_eval { @admin = true }
          end

          specify { expect(controller.send(:determine_layout)).to eq('admin') }
        end
      end

      describe '#is_admin' do
        it 'sets instance var for use in view' do
          controller.send(:is_admin)

          expect(assigns(:admin)).to eq(true)
        end
      end
    end
  end
end
