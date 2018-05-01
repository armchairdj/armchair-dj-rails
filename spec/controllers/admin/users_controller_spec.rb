# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_users_path }
    end
  end

  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":all scope (default)" do
          it "renders with one record because there has to be at least one admin" do
            get :index

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(1)
          end
        end

        context ":member scope" do
          it "renders" do
            get :index, params: { scope: "member" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(0).of_total_records(0)
          end
        end

        context ":writer scope" do
          it "renders" do
            get :index, params: { scope: "writer" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(0).of_total_records(0)
          end
        end

        context ":editor scope" do
          it "renders" do
            get :index, params: { scope: "editor" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(0).of_total_records(0)
          end
        end

        context ":admin scope" do
          it "renders with one record because we are logged in as admin" do
            get :index, params: { scope: "admin" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(1)
          end
        end

        context ":super_admin scope" do
          it "renders" do
            get :index, params: { scope: "super_admin" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(0).of_total_records(0)
          end
        end
      end

      context "with records" do
        context ":all scope (default)" do
          before(:each) do
             4.times { create(:member     ) }
             4.times { create(:writer     ) }
             4.times { create(:editor     ) }
             4.times { create(:admin      ) }
             4.times { create(:super_admin) }
          end

          it "renders" do
            get :index

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":member scope" do
          before(:each) do
            21.times { create(:member) }
          end

          it "renders" do
            get :index, params: { scope: "member" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "member", page: "2" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":writer scope" do
          before(:each) do
            21.times { create(:writer) }
          end

          it "renders" do
            get :index, params: { scope: "writer" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "writer", page: "2" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":editor scope" do
          before(:each) do
            21.times { create(:editor) }
          end

          it "renders" do
            get :index, params: { scope: "editor" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "editor", page: "2" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":admin scope" do
          before(:each) do
            20.times { create(:admin) }
          end

          it "renders" do
            get :index, params: { scope: "admin" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "admin", page: "2" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":super_admin scope" do
          before(:each) do
            21.times { create(:super_admin) }
          end

          it "renders" do
            get :index, params: { scope: "super_admin" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "super_admin", page: "2" }

            should successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end
      end
    end

    describe "GET #show" do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :show, params: { id: user.to_param }

        should successfully_render("admin/users/show")
        should assign(user, :user)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        should successfully_render("admin/users/new")
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST #create" do
      let(  :valid_params) { attributes_for(:complete_user) }
      let(:invalid_params) { attributes_for(:complete_user).except(:first_name) }

      context "with valid params" do
        it "creates a new User" do
          expect {
            post :create, params: { user: valid_params }
          }.to change(User, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { user: valid_params }

          should assign(User.last, :user).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { user: valid_params }

          should send_user_to(
            admin_user_path(assigns(:user))
          ).with_flash(:success, "admin.flash.users.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { user: invalid_params }

          should successfully_render("admin/users/new")

          expect(assigns(:user)).to have_coerced_attributes(invalid_params)
          expect(assigns(:user)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :edit, params: { id: user.to_param }

        should successfully_render("admin/users/edit")
        should assign(user, :user)
      end
    end

    describe "PUT #update" do
      let(:user) { create(:minimal_user) }

      let(  :valid_params) { { first_name: "New First Name" } }
      let(:invalid_params) { { first_name: ""               } }

      context "with valid params" do
        it "updates the requested user" do
          put :update, params: { id: user.to_param, user: valid_params }

          should assign(user, :user).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: user.to_param, user: valid_params }

          should send_user_to(
            admin_user_path(assigns(:user))
          ).with_flash(:success, "admin.flash.users.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: user.to_param, user: invalid_params }

          should successfully_render("admin/users/edit")

          should assign(user, :user).with_attributes(invalid_params).and_be_invalid
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

        should send_user_to(
          admin_users_path
        ).with_flash(:success, "admin.flash.users.success.destroy")
      end
    end
  end
end
