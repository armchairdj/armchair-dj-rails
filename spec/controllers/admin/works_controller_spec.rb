# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WorksController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_linkable_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let(:work) { create(:minimal_song) }

      it "renders" do
        get :show, params: { id: work.to_param }

        is_expected.to successfully_render("admin/works/show")
        is_expected.to assign(work, :work)
      end
    end

    describe "GET #new" do
      it "renders only the type dropdown" do
        get :new

        is_expected.to successfully_render("admin/works/new")
        expect(assigns(:work)).to be_a_new(Work)

        is_expected.to prepare_only_the_type_dropdown
      end
    end

    describe "POST #create" do
      let(:initial_params) { attributes_for(:work, type: "Song") }
      let(  :valid_params) { attributes_for(:junior_boys_like_a_child_c2_remix, type: "Song") }
      let(    :bad_params) { attributes_for(:junior_boys_like_a_child_c2_remix, type: "Song").except(:title) }

      context "with initial params" do
        it "renders new with full form but no errors" do
          post :create, params: { step: "select_work_type", work: initial_params }

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
          post :create, params: { work: bad_params }

          is_expected.to successfully_render("admin/works/new")

          expect(assigns(:work)).to have_coerced_attributes(bad_params)
          expect(assigns(:work)).to be_invalid

          is_expected.to prepare_the_work_dropdowns
        end
      end

      pending "max_params (aspects, milestones)"
    end

    describe "GET #edit" do
      let(:work) { create(:minimal_song) }

      it "renders" do
        get :edit, params: { id: work.to_param }

        is_expected.to successfully_render("admin/works/edit")
        is_expected.to assign(work, :work)
        is_expected.to prepare_the_work_dropdowns
      end
    end

    describe "PUT #update" do
      let(:work) { create(:minimal_song) }

      let(  :valid_params) { { title: "New Title" } }
      let(:bad_params) { { title: ""          } }

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
          put :update, params: { id: work.to_param, work: bad_params }

          is_expected.to successfully_render("admin/works/edit")

          expect(assigns(:work)       ).to eq(work)
          expect(assigns(:work).valid?).to eq(false)

          is_expected.to prepare_the_work_dropdowns
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:work) { create(:minimal_song) }

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
        expect(subject.keys).to match_array([
          "All",
          "Visible",
          "Hidden",
        ])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "ID",
          "Title",
          "Creator",
          "Medium",
          "Viewable",
        ])
      end
    end
  end
end
