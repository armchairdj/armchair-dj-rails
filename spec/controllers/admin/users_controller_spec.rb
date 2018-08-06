# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController do
  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index"
    end

    describe "GET #show" do
      let(:user) { create(:minimal_user) }

      subject { get :show, params: { id: user.to_param } }

      it { is_expected.to successfully_render("admin/users/show") }
      it { is_expected.to assign(user, :user) }
    end

    describe "GET #new" do
      subject { get :new }

      it { is_expected.to successfully_render("admin/users/new") }

      it { subject; expect(assigns(:user)).to be_a_new(User) }
    end

    describe "POST #create" do
      let(:valid_params) { attributes_for(:complete_user) }
      let(:bad_params) { attributes_for(:complete_user).except(:first_name) }

      context "with valid params" do
        subject { post :create, params: { user: valid_params } }

        it { expect { subject }.to change(User, :count).by(1) }

        it { is_expected.to assign(User.last, :user).with_attributes(valid_params).and_be_valid }

        it { is_expected.to send_user_to(admin_user_path(assigns(:user))) }

        it { is_expected.to have_flash(:success, "admin.flash.users.success.create") }
      end

      context "with invalid params" do
        subject { post :create, params: { user: bad_params } }

        it { is_expected.to successfully_render("admin/users/new") }

        it { subject; expect(assigns(:user)).to have_coerced_attributes(bad_params) }
        it { subject; expect(assigns(:user)).to be_invalid }
      end
    end

    describe "GET #edit" do
      let(:user) { create(:minimal_user) }

      subject { get :edit, params: { id: user.to_param } }

      it { is_expected.to successfully_render("admin/users/edit") }

      it { is_expected.to assign(user, :user) }
    end

    describe "PUT #update" do
      let(:user) { create(:minimal_user) }

      let(:valid_params) { { first_name: "New First Name" } }
      let(:bad_params) { { first_name: ""               } }

      context "with valid params" do
        subject do
          put :update, params: { id: user.to_param, user: valid_params }
        end

        it { is_expected.to assign(user, :user).with_attributes(valid_params).and_be_valid }

        it { is_expected.to send_user_to(admin_user_path(assigns(:user))) }

        it { is_expected.to have_flash(:success, "admin.flash.users.success.update") }
      end

      context "with invalid params" do
        subject do
          put :update, params: { id: user.to_param, user: bad_params }
        end

        it { is_expected.to successfully_render("admin/users/edit") }

        it { is_expected.to assign(user, :user).with_attributes(bad_params).and_be_invalid }
      end
    end

    describe "DELETE #destroy" do
      let!(:user) { create(:minimal_user) }

      subject { delete :destroy, params: { id: user.to_param } }

      it { expect { subject }.to change(User, :count).by(-1) }

      it { is_expected.to send_user_to(admin_users_path) }

      it { is_expected.to have_flash(:success, "admin.flash.users.success.destroy") }
    end
  end
end
