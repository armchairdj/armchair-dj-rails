require "rails_helper"

RSpec.describe Admin::CreatorsController, type: :controller do
  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":viewable scope (default)" do
          it "renders" do
            get :index

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(0).of_total_records(0)
          end
        end

        context ":non_viewable scope" do
          it "renders" do
            get :index, params: { scope: "non_viewable" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(0).of_total_records(0)
          end
        end

        context ":all scope" do
          it "renders" do
            get :index, params: { scope: "all" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(0).of_total_records(0)
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

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(1).of_total_records(21)
          end
        end

        context ":non_viewable scope" do
          before(:each) do
            21.times { create(:minimal_creator) }
          end

          it "renders" do
            get :index, params: { scope: "non_viewable" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "non_viewable", page: "2" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(1).of_total_records(21)
          end
        end

        context ":all scope" do
          before(:each) do
            10.times { create(:song_review, :published) }
            11.times { create(:minimal_creator) }
          end

          it "renders" do
            get :index, params: { scope: "all" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "all", page: "2" }

            expect(response).to successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(1).of_total_records(21)
          end
        end
      end
    end

    describe "GET #show" do
      let(:creator) { create(:minimal_creator) }

      it "renders" do
        get :show, params: { id: creator.to_param }

        expect(response).to successfully_render("admin/creators/show")

        expect(assigns(:creator)).to eq(creator)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        expect(response).to successfully_render("admin/creators/new")

        expect(assigns(:creator)).to be_a_new(Creator)
      end
    end

    describe "POST #create" do
      let(  :valid_params) { attributes_for(:minimal_creator) }
      let(:invalid_params) { attributes_for(:minimal_creator).except(:name) }

      context "with valid params" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: valid_params }
          }.to change(Creator, :count).by(1)
        end

        it "redirects to index" do
          post :create, params: { creator: valid_params }

          expect(response).to redirect_to(admin_creators_path)
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { creator: invalid_params }

          expect(response).to successfully_render("admin/creators/new")

          expect(assigns(:creator)       ).to be_a_new(Creator)
          expect(assigns(:creator).valid?).to eq(false)
        end
      end
    end

    describe "GET #edit" do
      let(:creator) { create(:minimal_creator) }

      it "renders" do
        get :edit, params: { id: creator.to_param }

        expect(response).to successfully_render("admin/creators/edit")

        expect(assigns(:creator)).to eq(creator)
      end
    end

    describe "PUT #update" do
      let(:creator) { create(:minimal_creator) }

      let(  :valid_params) { { name: "New Name" } }
      let(:invalid_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested creator" do
          put :update, params: { id: creator.to_param, creator: valid_params }

          creator.reload

          expect(creator.name).to eq(valid_params[:name])
        end

        it "redirects to index" do
          put :update, params: { id: creator.to_param, creator: valid_params }

          expect(response).to redirect_to(admin_creators_path)
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: creator.to_param, creator: invalid_params }

          expect(response).to successfully_render("admin/creators/edit")

          expect(assigns(:creator)       ).to eq(creator)
          expect(assigns(:creator).valid?).to eq(false)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:creator) { create(:minimal_creator) }

      it "destroys the requested creator" do
        expect {
          delete :destroy, params: { id: creator.to_param }
        }.to change(Creator, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: creator.to_param }

        expect(response).to redirect_to(admin_creators_path)
      end
    end
  end

  context "concerns" do
    it_behaves_like "an admin controller" do
      let(:expected_redirect_for_seo_paginatable) { admin_creators_path }
      let(:instance                             ) { create(:minimal_creator) }
    end
  end
end
