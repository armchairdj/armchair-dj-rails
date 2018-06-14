# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :show, params: { id: user.to_param }

        is_expected.to successfully_render("admin/users/show")
        is_expected.to assign(user, :user)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/users/new")
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST #create" do
      let(  :valid_params) { attributes_for(:complete_user) }
      let(:bad_params) { attributes_for(:complete_user).except(:first_name) }

      context "with valid params" do
        it "creates a new User" do
          expect {
            post :create, params: { user: valid_params }
          }.to change(User, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { user: valid_params }

          is_expected.to assign(User.last, :user).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { user: valid_params }

          is_expected.to send_user_to(
            admin_user_path(assigns(:user))
          ).with_flash(:success, "admin.flash.users.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { user: bad_params }

          is_expected.to successfully_render("admin/users/new")

          expect(assigns(:user)).to have_coerced_attributes(bad_params)
          expect(assigns(:user)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :edit, params: { id: user.to_param }

        is_expected.to successfully_render("admin/users/edit")
        is_expected.to assign(user, :user)
      end
    end

    describe "PUT #update" do
      let(:user) { create(:minimal_user) }

      let(  :valid_params) { { first_name: "New First Name" } }
      let(:bad_params) { { first_name: ""               } }

      context "with valid params" do
        it "updates the requested user" do
          put :update, params: { id: user.to_param, user: valid_params }

          is_expected.to assign(user, :user).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: user.to_param, user: valid_params }

          is_expected.to send_user_to(
            admin_user_path(assigns(:user))
          ).with_flash(:success, "admin.flash.users.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: user.to_param, user: bad_params }

          is_expected.to successfully_render("admin/users/edit")

          is_expected.to assign(user, :user).with_attributes(bad_params).and_be_invalid
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:user) { create(:minimal_user) }

      it "destroys the requested user" do
        expect {
          delete :destroy, params: { id: user.to_param }
        }.to change(User, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: user.to_param }

        is_expected.to send_user_to(
          admin_users_path
        ).with_flash(:success, "admin.flash.users.success.destroy")
      end
    end
  end

  context "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([
          "All",
          "Visible",
          "Hidden",
          "Member",
          "Writer",
          "Editor",
          "Admin",
          "Root"
        ])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "ID",
          "Name",
          "Username",
          "Email",
          "Role",
          "Viewable",
        ])
      end
    end
  end
end
