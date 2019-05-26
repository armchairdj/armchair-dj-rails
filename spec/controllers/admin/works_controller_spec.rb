# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WorksController do
  let(:instance) { create(:minimal_song) }

  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index"
    end

    describe "GET #show" do
      subject { get :show, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/works/show") }
      it { is_expected.to assign(instance, :work) }
    end

    describe "GET #new" do
      subject { get :new }

      it { is_expected.to successfully_render("admin/works/new") }

      it { is_expected.to prepare_the_initial_form }

      it { subject; expect(assigns(:work)).to be_a_new(Work) }
    end

    describe "POST #create" do
      let!(:source_work) { create(:junior_boys_like_a_child) }
      let!(:target_work) { create(:junior_boys_like_a_child_c2_remix_re_edit) }

      let(:initial_params) { attributes_for(:work, medium: "Song") }

      let(:max_params) do
        attributes_for(:junior_boys_like_a_child_c2_remix, medium: "Song").merge(
          source_relationships_attributes: {
            "0" => { connection: "version_of", source_id: source_work.id }
          },
          target_relationships_attributes: {
            "0" => { connection: "version_of", target_id: target_work.id }
          }
        )
      end

      let(:bad_params) { attributes_for(:junior_boys_like_a_child_c2_remix, medium: "Song").except(:title) }

      context "with initial params" do
        subject { post :create, params: { step: "select_medium", work: initial_params } }

        it { is_expected.to successfully_render("admin/works/new") }

        it { subject; expect(assigns(:work)).to have_coerced_attributes(initial_params) }

        it { subject; expect(assigns(:work).errors).to match_array([]) }

        it { is_expected.to prepare_the_complete_form }
      end

      context "with valid params" do
        subject { post :create, params: { work: max_params } }

        it { expect { subject }.to change(Work,               :count).by(1) }
        it { expect { subject }.to change(Work::Relationship, :count).by(2) }
        it { expect { subject }.to change(Work::Milestone,    :count).by(1) }
        it { expect { subject }.to change(Credit,             :count).by(1) }
        it { expect { subject }.to change(Contribution,       :count).by(1) }

        it { is_expected.to assign(Work.last, :work).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_work_path(assigns(:work))) }

        it { is_expected.to have_flash(:success, "admin.flash.works.success.create") }
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
    end

    describe "GET #edit" do
      subject { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/works/edit") }

      it { is_expected.to assign(instance, :work) }

      it { is_expected.to prepare_the_complete_form }
    end

    describe "PUT #update" do
      let(:update_params    ) { { title: "New Title" } }
      let(:bad_update_params) { { title: ""          } }

      context "with valid params" do
        subject { put :update, params: { id: instance.to_param, work: update_params } }

        it { is_expected.to assign(instance, :work).with_attributes(update_params).and_be_valid }

        it { is_expected.to send_user_to(admin_work_path(assigns(:work))) }

        it { is_expected.to have_flash(:success, "admin.flash.works.success.update") }
      end

      context "with invalid params" do
        subject { put :update, params: { id: instance.to_param, work: bad_update_params } }

        it { is_expected.to successfully_render("admin/works/edit") }

        it { is_expected.to assign(instance, :work).with_attributes(bad_update_params).and_be_invalid }

        it { is_expected.to prepare_the_complete_form }
      end
    end

    describe "DELETE #destroy" do
      let!(:source_work) { create(:junior_boys_like_a_child) }

      let!(:instance) do
        create(:junior_boys_like_a_child_c2_remix, source_relationships_attributes: {
          "0" => { connection: "version_of", source_id: source_work.id }
        } )
      end

      subject { delete :destroy, params: { id: instance.to_param } }

      it { expect { subject }.to change(Work,               :count).by(-1) }
      it { expect { subject }.to change(Work::Milestone,    :count).by(-1) }
      it { expect { subject }.to change(Work::Relationship, :count).by(-1) }
      it { expect { subject }.to change(Credit,             :count).by(-1) }
      it { expect { subject }.to change(Contribution,       :count).by(-1) }

      it { is_expected.to send_user_to(admin_works_path) }

      it { is_expected.to have_flash(:success, "admin.flash.works.success.destroy") }
    end

    describe "POST #reorder_credits" do
      let(:instance) { create(:minimal_work, maker_count: 5) }
      let(:shuffled) { instance.credits.ids.shuffle }

      describe "non-xhr" do
        subject do
          post :reorder_credits, params: { id: instance.to_param, credit_ids: shuffled }
        end

        it { is_expected.to render_bad_request }
      end

      describe "xhr" do
        let(:operation) do
          post :reorder_credits, xhr: true, params: { id: instance.to_param, credit_ids: shuffled }
        end

        subject { operation }

        it { expect(response).to have_http_status(200) }

        describe "reordering" do
          subject { operation; instance.reload.credits.ids }

          it { is_expected.to eq(shuffled) }
        end
      end
    end
  end
end
