require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":all scope (default)" do
          it "renders with one record because there has to be at least one admin" do
            get :index

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(1)
          end
        end

        context ":member scope" do
          it "renders" do
            get :index, params: { scope: "member" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(0).of_total_records(0)
          end
        end

        context ":contributor scope" do
          it "renders" do
            get :index, params: { scope: "contributor" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(0).of_total_records(0)
          end
        end

        context ":admin scope" do
          it "renders with one record because there has to be at least one admin" do
            get :index, params: { scope: "admin" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(1)
          end
        end
      end

      context "with records" do
        context ":all scope (default)" do
          before(:each) do
             5.times { create(:admin) }
             5.times { create(:contributor) }
            10.times { create(:member) }
          end

          it "renders" do
            get :index

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":member scope" do
          before(:each) do
            21.times { create(:member) }
          end

          it "renders" do
            get :index, params: { scope: "member" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "member", page: "2" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":contributor scope" do
          before(:each) do
            21.times { create(:contributor) }
          end

          it "renders" do
            get :index, params: { scope: "contributor" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "contributor", page: "2" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end

        context ":admin scope" do
          before(:each) do
            20.times { create(:admin) }
          end

          it "renders" do
            get :index, params: { scope: "admin" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "admin", page: "2" }

            expect(response).to successfully_render("admin/users/index")
            expect(assigns(:users)).to paginate(1).of_total_records(21)
          end
        end
      end
    end

    describe "GET #show" do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :show, params: { id: user.to_param }

        expect(response).to successfully_render("admin/users/show")
        expect(assigns(:user)).to eq(user)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        expect(response).to successfully_render("admin/users/new")
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST #create" do
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

          expect(response).to successfully_render("admin/users/new")

          expect(assigns(:user)       ).to be_a_new(User)
          expect(assigns(:user).valid?).to eq(false)
        end
      end
    end

    describe "GET #edit" do
      let(:user) { create(:minimal_user) }

      it "renders" do
        get :edit, params: { id: user.to_param }

        expect(response).to successfully_render("admin/users/edit")

        expect(assigns(:user)).to eq(user)
      end
    end

    describe "PUT #update" do
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

          expect(response).to successfully_render("admin/users/edit")

          expect(assigns(:user)       ).to eq(user)
          expect(assigns(:user).valid?).to eq(false)
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

        expect(response).to redirect_to(admin_users_path)
      end
    end
  end

  context "concerns" do
    it_behaves_like "an admin controller" do
      let(:expected_redirect_for_seo_paginatable) { admin_users_path }
      let(:instance                             ) { create(:minimal_user) }
    end
  end
end
