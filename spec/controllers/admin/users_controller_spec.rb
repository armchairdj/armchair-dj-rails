require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  context "as admin" do
    login_admin

    describe 'GET #index' do
      pending 'scopes'

      context "with records" do
        before(:each) do
          (per_page).times { create(:minimal_user) }
        end

        it "renders" do
          get :index

          expect(response).to be_success
          expect(response).to render_template("admin/users/index")

          expect(assigns(:users).total_count).to eq(per_page + 1)
          expect(assigns(:users).length     ).to eq(per_page)
        end

        it "renders second page" do
          get :index, params: { page: 2 }

          expect(response).to be_success
          expect(response).to render_template("admin/users/index")

          expect(assigns(:users).total_count).to eq(per_page + 1)
          expect(assigns(:users).length     ).to eq(1)
        end
      end
    end

    describe 'GET #show' do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :show, params: { id: user.to_param }

        expect(response).to be_success
        expect(response).to render_template("admin/users/show")

        expect(assigns(:user)).to eq(user)
      end
    end

    describe 'GET #new' do
      it "renders" do
        get :new

        expect(response).to be_success
        expect(response).to render_template("admin/users/new")

        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe 'POST #create' do
      let(  :valid_params) { attributes_for(:minimal_user) }
      let(:invalid_params) { attributes_for(:minimal_user).except(:first_name) }

      context "with valid params" do
        it "creates a new User" do
          expect {
            post :create, params: { user: valid_params }
          }.to change(User, :count).by(1)
        end

        it "redirects to index" do
          post :create, params: { user: valid_params }

          expect(response).to redirect_to(admin_users_path)
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { user: invalid_params }

          expect(response).to be_success
          expect(response).to render_template("admin/users/new")

          expect(assigns(:user)       ).to be_a_new(User)
          expect(assigns(:user).valid?).to eq(false)
        end
      end
    end

    describe 'GET #edit' do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :edit, params: { id: user.to_param }

        expect(response).to be_success
        expect(response).to render_template("admin/users/edit")

        expect(assigns(:user)).to eq(user)
      end
    end

    describe 'PUT #update' do
      let(:user) { create(:minimal_user) }

      let(  :valid_params) { { first_name: "New First Name" } }
      let(:invalid_params) { { first_name: ""         } }

      context "with valid params" do
        it "updates the requested user" do
          put :update, params: { id: user.to_param, user: valid_params }

          user.reload

          expect(user.first_name).to eq(valid_params[:first_name])
        end

        it "redirects to index" do
          put :update, params: { id: user.to_param, user: valid_params }

          expect(response).to redirect_to(admin_users_path)
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: user.to_param, user: invalid_params }

          expect(response).to be_success
          expect(response).to render_template("admin/users/edit")

          expect(assigns(:user)       ).to eq(user)
          expect(assigns(:user).valid?).to eq(false)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:user) { create(:minimal_user) }

      it "destroys the requested user" do
        expect {
          delete :destroy, params: { id: user.to_param }
        }.to change(User, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: user.to_param }

        expect(response).to redirect_to(admin_users_path)
      end
    end
  end

  context "concerns" do
    it_behaves_like "an seo paginatable controller" do
      let(:expected_redirect) { admin_users_path }
    end
  end
end
