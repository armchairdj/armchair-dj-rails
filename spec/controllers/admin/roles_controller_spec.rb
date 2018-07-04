# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::RolesController, type: :controller do
  let(:type_options) { Work.type_options }
  let(        :role) { create(:minimal_role, work_type: type_options.first.last) }

  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      it "renders" do
        get :show, params: { id: role.to_param }

        is_expected.to successfully_render("admin/roles/show")

        is_expected.to assign(role, :role)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/roles/new")

        expect(assigns(:role)).to be_a_new(Role)

        expect(assigns(:work_types)).to match_array(type_options)
      end
    end

    describe "POST #create" do
      let(:max_params) { attributes_for(:complete_role, work_type: type_options.first.last) }
      let(:min_params) { attributes_for(:minimal_role,  work_type: type_options.first.last) }
      let(:bad_params) { attributes_for(:minimal_role).except(:name) }

      context "with min valid params" do
        it "creates a new Role" do
          expect {
            post :create, params: { role: min_params }
          }.to change(Role, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { role: min_params }

          is_expected.to assign(Role.last, :role).with_attributes(min_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { role: min_params }

          is_expected.to send_user_to(
            admin_role_path(assigns(:role))
          ).with_flash(:success, "admin.flash.roles.success.create")
        end
      end

      context "with max valid params" do
        it "creates a new Role" do
          expect {
            post :create, params: { role: max_params }
          }.to change(Role, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { role: max_params }

          is_expected.to assign(Role.last, :role).with_attributes(max_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { role: max_params }

          is_expected.to send_user_to(
            admin_role_path(assigns(:role))
          ).with_flash(:success, "admin.flash.roles.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { role: bad_params }

          is_expected.to successfully_render("admin/roles/new")

          expect(assigns(:role)).to have_coerced_attributes(bad_params)
          expect(assigns(:role)).to be_invalid

          expect(assigns(:work_types)).to match_array(type_options)
        end
      end
    end

    describe "GET #edit" do
      it "renders" do
        get :edit, params: { id: role.to_param }

        is_expected.to successfully_render("admin/roles/edit")

        is_expected.to assign(role, :role)

        expect(assigns(:work_types)).to match_array(type_options)
      end
    end

    describe "PUT #update" do
      let(    :update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested role" do
          put :update, params: { id: role.to_param, role: update_params }

          is_expected.to assign(role, :role).with_attributes(update_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: role.to_param, role: update_params }

          is_expected.to send_user_to(
            admin_role_path(assigns(:role))
          ).with_flash(:success, "admin.flash.roles.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: role.to_param, role: bad_update_params }

          is_expected.to successfully_render("admin/roles/edit")

          is_expected.to assign(role, :role).with_attributes(bad_update_params).and_be_invalid

          expect(assigns(:work_types)).to match_array(type_options)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:role) { create(:minimal_role) }

      it "destroys the requested role" do
        expect {
          delete :destroy, params: { id: role.to_param }
        }.to change(Role, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: role.to_param }

        is_expected.to send_user_to(admin_roles_path).with_flash(
          :success, "admin.flash.roles.success.destroy"
        )
      end
    end
  end

  describe "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([
          "All",
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
          "Medium",
        ])
      end
    end
  end
end
