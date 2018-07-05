# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WorksController, type: :controller do
  let(:work) { create(:minimal_song) }

  describe "concerns" do
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

        is_expected.to prepare_the_initial_form
      end
    end

    describe "POST #create" do
      let(:initial_params) { attributes_for(:work, medium: "Song") }
      let(    :max_params) { attributes_for(:junior_boys_like_a_child_c2_remix, medium: "Song") }
      let(    :bad_params) { attributes_for(:junior_boys_like_a_child_c2_remix, medium: "Song").except(:title) }

      context "with initial params" do
        it "renders new with full form but no errors" do
          post :create, params: { step: "select_medium", work: initial_params }

          is_expected.to successfully_render("admin/works/new")

          expect(assigns(:work)       ).to have_coerced_attributes(initial_params)
          expect(assigns(:work).errors).to match_array([])

          is_expected.to prepare_the_complete_form
        end
      end

      context "with valid params" do
        subject { post :create, params: { work: max_params } }

        it { expect { subject }.to change(Work, :count).by(1) }

        it { is_expected.to assign(Work.last, :work).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_work_path(assigns(:work))).with_flash(
          :success, "admin.flash.works.success.create"
        ) }
      end

      context "with invalid params" do
        let(:operation) { post :create, params: { work: bad_params } }

        it { expect { operation }.to_not change(Work, :count) }

        describe "response" do
          subject { operation }

          it { is_expected.to successfully_render("admin/works/new") }
          it { is_expected.to prepare_the_complete_form }

          describe "instance" do
            subject { operation; assigns(:work) }

            it { is_expected.to have_coerced_attributes(bad_params) }
            it { is_expected.to be_invalid }
          end
        end
      end

      pending "max_params (aspects, milestones)"
    end

    describe "GET #edit" do
      it "renders" do
        get :edit, params: { id: work.to_param }

        is_expected.to successfully_render("admin/works/edit")
        is_expected.to assign(work, :work)
        is_expected.to prepare_the_complete_form
      end
    end

    describe "PUT #update" do
      let(    :update_params) { { title: "New Title" } }
      let(:bad_update_params) { { title: ""          } }

      context "with valid params" do
        it "updates the requested work" do
          put :update, params: { id: work.to_param, work: update_params }

          work.reload

          expect(work.title).to eq(update_params[:title])
        end

        it "redirects to index" do
          put :update, params: { id: work.to_param, work: update_params }

          is_expected.to send_user_to(
            admin_work_path(assigns(:work))
          ).with_flash(:success, "admin.flash.works.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: work.to_param, work: bad_update_params }

          is_expected.to successfully_render("admin/works/edit")

          expect(assigns(:work)       ).to eq(work)
          expect(assigns(:work).valid?).to eq(false)

          is_expected.to prepare_the_complete_form
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:work) { create(:junior_boys_like_a_child_c2_remix) }

      it "destroys the requested work" do
        expect {
          delete :destroy, params: { id: work.to_param }
        }.to change(Work, :count).by(-1)
      end

      it "destroys associated credits" do
        expect {
          delete :destroy, params: { id: work.to_param }
        }.to change(Credit, :count).by(-1)
      end

      it "destroys associated contributions" do
        expect {
          delete :destroy, params: { id: work.to_param }
        }.to change(Contribution, :count).by(-1)
      end

      it "destroys associated milestones" do
        expect {
          delete :destroy, params: { id: work.to_param }
        }.to change(Milestone, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: work.to_param }

        is_expected.to send_user_to(
          admin_works_path
        ).with_flash(:success, "admin.flash.works.success.destroy")
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
          "Title",
          "Creator",
          "Medium",
        ])
      end
    end
  end
end
