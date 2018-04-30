# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CreatorsController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller" do
      let(:expected_redirect_for_seo_paginatable) { admin_creators_path }
      let(:instance                             ) { create(:minimal_creator) }
    end
  end

  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":all scope (default)" do
          it "renders" do
            get :index

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(0).of_total_records(0)
          end
        end

        context ":viewable scope" do
          it "renders" do
            get :index, params: { scope: "viewable" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(0).of_total_records(0)
          end
        end

        context ":non_viewable scope" do
          it "renders" do
            get :index, params: { scope: "non_viewable" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(0).of_total_records(0)
          end
        end
      end

      context "with records" do
        context ":all scope (default)" do
          before(:each) do
            10.times { create(:song_review, :published) }
            11.times { create(:minimal_creator) }
          end

          it "renders" do
            get :index

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(1).of_total_records(21)
          end
        end

        context ":viewable scope" do
          before(:each) do
            21.times { create(:song_review, :published) }
          end

          it "renders" do
            get :index, params: { scope: "viewable" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "viewable", page: "2" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(1).of_total_records(21)
          end
        end

        context ":non_viewable scope" do
          before(:each) do
            21.times { create(:minimal_creator) }
          end

          it "renders" do
            get :index, params: { scope: "non_viewable" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "non_viewable", page: "2" }

            should successfully_render("admin/creators/index")
            expect(assigns(:creators)).to paginate(1).of_total_records(21)
          end
        end
      end
    end

    describe "GET #show" do
      let(:creator) { create(:minimal_creator) }

      it "renders" do
        get :show, params: { id: creator.to_param }

        should successfully_render("admin/creators/show")
        should assign(creator, :creator)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        should successfully_render("admin/creators/new")
        expect(assigns(:creator)).to be_a_populated_new_creator
      end
    end

    describe "POST #create" do
      let(    :max_params) { attributes_for(:minimal_creator, :with_summary, :with_new_member, :with_new_pseudonym) }
      let(:alt_max_params) { attributes_for(:minimal_creator, :with_summary, :with_new_group,  :with_new_real_name) }
      let(  :valid_params) { attributes_for(:minimal_creator) }
      let(:invalid_params) { attributes_for(:minimal_creator).except(:name) }

      context "with max valid params including memeber and pseudonym" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: max_params }
          }.to change(Creator, :count).by(3)
        end

        it "creates a new Identity" do
          expect {
            post :create, params: { creator: max_params }
          }.to change(Identity, :count).by(1)
        end

        it "creates a new Membership" do
          expect {
            post :create, params: { creator: max_params }
          }.to change(Membership, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { creator: max_params }

          should assign(Creator.last, :creator).with_attributes(max_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { creator: max_params }

          should send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.create")
        end
      end

      context "with max valid params including group and real_name" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: alt_max_params }
          }.to change(Creator, :count).by(3)
        end

        it "creates a new Identity" do
          expect {
            post :create, params: { creator: alt_max_params }
          }.to change(Identity, :count).by(1)
        end

        it "creates a new Membership" do
          expect {
            post :create, params: { creator: alt_max_params }
          }.to change(Membership, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { creator: alt_max_params }

          should assign(Creator.last, :creator).with_attributes(alt_max_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { creator: alt_max_params }

          should send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.create")
        end
      end

      context "with min valid params" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: valid_params }
          }.to change(Creator, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { creator: valid_params }

          should assign(Creator.last, :creator).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { creator: valid_params }

          should send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { creator: invalid_params }

          should successfully_render("admin/creators/new")

          expect(assigns(:creator)).to be_a_populated_new_creator
          expect(assigns(:creator)).to have_coerced_attributes(invalid_params)
        end
      end
    end

    describe "GET #edit" do
      let(:creator) { create(:minimal_creator) }

      it "renders" do
        get :edit, params: { id: creator.to_param }

        should successfully_render("admin/creators/edit")
        should assign(creator, :creator)
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

          should send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: creator.to_param, creator: invalid_params }

          should successfully_render("admin/creators/edit")

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

        should send_user_to(
          admin_creators_path
        ).with_flash(:success, "admin.flash.creators.success.destroy")
      end
    end
  end
end
