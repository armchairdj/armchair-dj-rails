require 'rails_helper'

RSpec.describe Admin::WorksController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  context "as admin" do
    login_admin

    describe 'GET #index' do
      pending 'scopes'

      context "without records" do
        it "renders" do
          get :index

          expect(response).to be_success
          expect(response).to render_template("admin/works/index")

          expect(assigns(:works).total_count).to eq(0)
          expect(assigns(:works).size       ).to eq(0)
        end
      end

      context "with records" do
        before(:each) do
          (per_page + 1).times { create(:minimal_work) }
        end

        it "renders" do
          get :index

          expect(response).to be_success
          expect(response).to render_template("admin/works/index")

          expect(assigns(:works).total_count).to eq(per_page + 1)
          expect(assigns(:works).size       ).to eq(per_page)
        end

        it "renders second page" do
          get :index, params: { page: 2 }

          expect(response).to be_success
          expect(response).to render_template("admin/works/index")

          expect(assigns(:works).total_count).to eq(per_page + 1)
          expect(assigns(:works).size       ).to eq(1)
        end
      end
    end

    describe 'GET #show' do
      let(:work) { create(:minimal_work) }

      it "renders" do
        get :show, params: { id: work.to_param }

        expect(response).to be_success
        expect(response).to render_template("admin/works/show")

        expect(assigns(:work)).to eq(work)
      end
    end

    describe 'GET #new' do
      it "renders" do
        get :new

        expect(response).to be_success
        expect(response).to render_template("admin/works/new")

        expect(assigns(:work)).to be_a_new(Work)
      end
    end

    describe 'POST #create' do
      let(  :valid_params) { attributes_for(:minimal_work) }
      let(:invalid_params) { attributes_for(:minimal_work).except(:title) }

      context "with valid params" do
        it "creates a new Work" do
          expect {
            post :create, params: { work: valid_params }
          }.to change(Work, :count).by(1)
        end

        it "redirects to index" do
          post :create, params: { work: valid_params }

          expect(response).to redirect_to(admin_works_path)
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { work: invalid_params }

          expect(response).to be_success
          expect(response).to render_template("admin/works/new")

          expect(assigns(:work)       ).to be_a_new(Work)
          expect(assigns(:work).valid?).to eq(false)
        end
      end
    end

    describe 'GET #edit' do
      let(:work) { create(:minimal_work) }

      it "renders" do
        get :edit, params: { id: work.to_param }

        expect(response).to be_success
        expect(response).to render_template("admin/works/edit")

        expect(assigns(:work)).to eq(work)
      end
    end

    describe 'PUT #update' do
      let(:work) { create(:minimal_work) }

      let(  :valid_params) { { title: "New Title" } }
      let(:invalid_params) { { title: ""          } }

      context "with valid params" do
        it "updates the requested work" do
          put :update, params: { id: work.to_param, work: valid_params }

          work.reload

          expect(work.title).to eq(valid_params[:title])
        end

        it "redirects to index" do
          put :update, params: { id: work.to_param, work: valid_params }

          expect(response).to redirect_to(admin_works_path)
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: work.to_param, work: invalid_params }

          expect(response).to be_success
          expect(response).to render_template("admin/works/edit")

          expect(assigns(:work)       ).to eq(work)
          expect(assigns(:work).valid?).to eq(false)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:work) { create(:minimal_work) }

      it "destroys the requested work" do
        expect {
          delete :destroy, params: { id: work.to_param }
        }.to change(Work, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: work.to_param }

        expect(response).to redirect_to(admin_works_path)
      end
    end
  end

  context "concerns" do
    it_behaves_like "an seo paginatable controller" do
      let(:expected_redirect) { admin_works_path }
    end
  end
end
