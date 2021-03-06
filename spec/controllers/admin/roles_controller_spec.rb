# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::RolesController do
  let(:media) { Work.media }
  let(:role) { create(:minimal_role, medium: media.first.last) }

  it_behaves_like "a_paginatable_controller"

  context "with root user" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index"
    end

    describe "GET #show" do
      subject { get :show, params: { id: role.to_param } }

      it { is_expected.to successfully_render("admin/roles/show") }

      it { is_expected.to assign(role, :role) }
    end

    describe "GET #new" do
      subject(:send_request) { get :new }

      it { is_expected.to successfully_render("admin/roles/new") }

      it "assigns ivars" do
        send_request

        expect(assigns(:role)).to be_a_new(Role)
        expect(assigns(:media)).to match_array(media)
      end
    end

    describe "POST #create" do
      let(:max_params) { attributes_for(:complete_role, medium: media.first.last) }
      let(:min_params) { attributes_for(:minimal_role,  medium: media.first.last) }
      let(:bad_params) { attributes_for(:minimal_role).except(:name) }

      context "with min valid params" do
        subject(:send_request) { post :create, params: { role: min_params } }

        it { expect { send_request }.to change(Role, :count).by(1) }

        it { is_expected.to assign(Role.last, :role).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_role_path(assigns(:role))) }

        it { is_expected.to have_flash(:success, "admin.flash.roles.success.create") }
      end

      context "with max valid params" do
        subject(:send_request) { post :create, params: { role: max_params } }

        it { expect { send_request }.to change(Role, :count).by(1) }

        it { is_expected.to assign(Role.last, :role).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_role_path(assigns(:role))) }

        it { is_expected.to have_flash(:success, "admin.flash.roles.success.create") }
      end

      context "with invalid params" do
        subject(:send_request) { post :create, params: { role: bad_params } }

        it { is_expected.to successfully_render("admin/roles/new") }

        it "assigns ivars" do
          send_request

          expect(assigns(:role)).to have_coerced_attributes(bad_params)
          expect(assigns(:role)).to be_invalid
          expect(assigns(:media)).to match_array(media)
        end
      end
    end

    describe "GET #edit" do
      subject(:send_request) { get :edit, params: { id: role.to_param } }

      it { is_expected.to successfully_render("admin/roles/edit") }

      it { is_expected.to assign(role, :role) }

      it "assigns ivars" do
        send_request

        expect(assigns(:media)).to match_array(media)
      end
    end

    describe "PUT #update" do
      let(:update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: "" } }

      context "with valid params" do
        subject do
          put :update, params: { id: role.to_param, role: update_params }
        end

        it { is_expected.to assign(role, :role).with_attributes(update_params).and_be_valid }

        it { is_expected.to send_user_to(admin_role_path(assigns(:role))) }

        it { is_expected.to have_flash(:success, "admin.flash.roles.success.update") }
      end

      context "with invalid params" do
        subject(:send_request) do
          put :update, params: { id: role.to_param, role: bad_update_params }
        end

        it { is_expected.to successfully_render("admin/roles/edit") }

        it { is_expected.to assign(role, :role).with_attributes(bad_update_params).and_be_invalid }

        it "assigns ivars" do
          send_request

          expect(assigns(:media)).to match_array(media)
        end
      end
    end

    describe "DELETE #destroy" do
      subject(:send_request) { delete :destroy, params: { id: role.to_param } }

      let!(:role) { create(:minimal_role) }

      it { expect { send_request }.to change(Role, :count).by(-1) }

      it { is_expected.to send_user_to(admin_roles_path) }

      it { is_expected.to have_flash(:success, "admin.flash.roles.success.destroy") }
    end
  end
end
