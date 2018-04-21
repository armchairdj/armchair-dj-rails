require "rails_helper"

RSpec.describe Admin::WorksController, type: :controller do
  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":viewable scope (default)" do
          it "renders" do
            get :index

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(0).of_total(0).records
          end
        end

        context ":non_viewable scope" do
          it "renders" do
            get :index, params: { scope: "non_viewable" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(0).of_total(0).records
          end
        end

        context ":all scope" do
          it "renders" do
            get :index, params: { scope: "all" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(0).of_total(0).records
          end
        end
      end

      context "with records" do
        context ":viewable scope (default)" do
          before(:each) do
            21.times { create(:song_review, :published) }
          end

          it "renders" do
            get :index

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(20).of_total(21).records
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(1).of_total(21).records
          end
        end

        context ":non_viewable scope" do
          before(:each) do
            21.times { create(:minimal_work) }
          end

          it "renders" do
            get :index, params: { scope: "non_viewable" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(20).of_total(21).records
          end

          it "renders second page" do
            get :index, params: { scope: "non_viewable", page: "2" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(1).of_total(21).records
          end
        end

        context ":all scope" do
          before(:each) do
            10.times { create(:song_review, :published) }
            11.times { create(:minimal_work) }
          end

          it "renders" do
            get :index, params: { scope: "all" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(20).of_total(21).records
          end

          it "renders second page" do
            get :index, params: { scope: "all", page: "2" }

            expect(response).to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(1).of_total(21).records
          end
        end
      end
    end

    describe "GET #show" do
      let(:work) { create(:minimal_work) }

      it "renders" do
        get :show, params: { id: work.to_param }

        expect(response).to successfully_render("admin/works/show")

        expect(assigns(:work)).to eq(work)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        expect(response).to successfully_render("admin/works/new")

        expect(assigns(:work)).to be_a_new(Work)
      end
    end

    describe "POST #create" do
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

          expect(response).to successfully_render("admin/works/new")

          expect(assigns(:work)       ).to be_a_new(Work)
          expect(assigns(:work).valid?).to eq(false)
        end
      end
    end

    describe "GET #edit" do
      let(:work) { create(:minimal_work) }

      it "renders" do
        get :edit, params: { id: work.to_param }

        expect(response).to successfully_render("admin/works/edit")

        expect(assigns(:work)).to eq(work)
      end
    end

    describe "PUT #update" do
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

          expect(response).to successfully_render("admin/works/edit")

          expect(assigns(:work)       ).to eq(work)
          expect(assigns(:work).valid?).to eq(false)
        end
      end
    end

    describe "DELETE #destroy" do
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
    it_behaves_like "an admin controller" do
      let(:expected_redirect_for_seo_paginatable) { admin_works_path }
      let(:instance                             ) { create(:minimal_work) }
    end
  end
end
