# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WorksController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_linkable_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_works_path }
    end
  end

  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context "All scope (default)" do
          it "renders" do
            get :index

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(0).of_total_records(0)
          end
        end

        context "Visible scope" do
          it "renders" do
            get :index, params: { scope: "Visible" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(0).of_total_records(0)
          end
        end

        context "Hidden scope" do
          it "renders" do
            get :index, params: { scope: "Hidden" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(0).of_total_records(0)
          end
        end
      end

      context "with records" do
        context "All scope (default)" do
          before(:each) do
            10.times { create(:review, :published) }
            11.times { create(:minimal_work) }
          end

          it "renders" do
            get :index

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(1).of_total_records(21)
          end
        end

        context "Visible scope" do
          before(:each) do
            21.times { create(:review, :published) }
          end

          it "renders" do
            get :index, params: { scope: "Visible" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "Visible", page: "2" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(1).of_total_records(21)
          end
        end

        context "Hidden scope" do
          before(:each) do
            21.times { create(:minimal_work) }
          end

          it "renders" do
            get :index, params: { scope: "Hidden" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "Hidden", page: "2" }

            is_expected.to successfully_render("admin/works/index")

            expect(assigns(:works)).to paginate(1).of_total_records(21)
          end
        end
      end

      context "sorts" do
        pending "Title"
        pending "Creator"
        pending "Medium"
        pending "VPC"
        pending "NVPC"
      end
    end

    describe "GET #show" do
      let(:work) { create(:minimal_work) }

      it "renders" do
        get :show, params: { id: work.to_param }

        is_expected.to successfully_render("admin/works/show")
        is_expected.to assign(work, :work)
      end
    end

    describe "GET #new" do
      it "renders only the media dropdown" do
        get :new

        is_expected.to successfully_render("admin/works/new")
        expect(assigns(:work)).to be_a_new(Work)

        is_expected.to prepare_only_the_media_dropdown
      end
    end

    describe "POST #create" do
      let(:initial_params) { attributes_for(:work, :with_existing_medium) }
      let(  :valid_params) { attributes_for(:junior_boys_like_a_child_c2_remix, :with_summary) }
      let(:invalid_params) { attributes_for(:junior_boys_like_a_child_c2_remix).except(:title) }

      context "with initial params" do
        it "renders new with full form but no errors" do
          post :create, params: { step: "select_medium", work: initial_params }

          is_expected.to successfully_render("admin/works/new")

          expect(assigns(:work)       ).to have_coerced_attributes(initial_params)
          expect(assigns(:work).errors).to match_array([])

          is_expected.to prepare_the_work_dropdowns
        end
      end

      context "with valid params" do
        it "creates a new Work" do
          expect {
            post :create, params: { work: valid_params }
          }.to change(Work, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { work: valid_params }

          is_expected.to assign(Work.last, :work).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { work: valid_params }

          is_expected.to send_user_to(
            admin_work_path(assigns(:work))
          ).with_flash(:success, "admin.flash.works.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { work: invalid_params }

          is_expected.to successfully_render("admin/works/new")

          expect(assigns(:work)).to have_coerced_attributes(invalid_params)
          expect(assigns(:work)).to be_invalid

          is_expected.to prepare_the_work_dropdowns
        end
      end

      pending "with tags"
    end

    describe "GET #edit" do
      context "plain jane" do
        let(:work) { create(:minimal_work) }

        it "renders" do
          get :edit, params: { id: work.to_param }

          is_expected.to successfully_render("admin/works/edit")
          is_expected.to assign(work, :work)

          expect(assigns(:work).credits).to have(4).items

          is_expected.to prepare_the_work_dropdowns
        end
      end

      context "with contribution" do
        let(:work) { create(:minimal_work, :with_one_contribution) }

        it "renders" do
          get :edit, params: { id: work.to_param }

          is_expected.to successfully_render("admin/works/edit")
          is_expected.to assign(work, :work)
          expect(assigns(:work).contributions).to have(11).items
        end
      end

      pending "with tags"
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

          is_expected.to send_user_to(
            admin_work_path(assigns(:work))
          ).with_flash(:success, "admin.flash.works.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: work.to_param, work: invalid_params }

          is_expected.to successfully_render("admin/works/edit")

          expect(assigns(:work)       ).to eq(work)
          expect(assigns(:work).valid?).to eq(false)

          is_expected.to prepare_the_work_dropdowns
        end
      end

      pending "with tags"
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

        is_expected.to send_user_to(
          admin_works_path
        ).with_flash(:success, "admin.flash.works.success.destroy")
      end
    end
  end

  context "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to eq([
          "All",
          "Visible",
          "Hidden",
        ])
      end
    end

    pending "allowed_sorts"
  end
end
