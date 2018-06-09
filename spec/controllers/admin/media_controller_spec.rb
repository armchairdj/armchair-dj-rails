# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MediaController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_media_path }
    end
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let(:medium) { create(:minimal_medium) }

      it "renders" do
        get :show, params: { id: medium.to_param }

        is_expected.to successfully_render("admin/media/show")
        is_expected.to assign(medium, :medium)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/media/new")

        expect(assigns(:medium)).to be_a_populated_new_medium
      end
    end

    describe "POST #create" do
      context "with min valid params" do
        let(:min_valid_params) { attributes_for(:minimal_medium) }

        it "creates a new Medium" do
          expect {
            post :create, params: { medium: min_valid_params }
          }.to change(Medium, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { medium: min_valid_params }

          is_expected.to assign(Medium.last, :medium).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { medium: min_valid_params }

          is_expected.to send_user_to(
            admin_medium_path(assigns(:medium))
          ).with_flash(:success, "admin.flash.media.success.create")
        end
      end

      context "with max valid params" do
        let(:max_valid_params) { attributes_for(:complete_medium) }

        it "creates a new Medium" do
          expect {
            post :create, params: { medium: max_valid_params }
          }.to change(Medium, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { medium: max_valid_params }

          is_expected.to assign(Medium.last, :medium).with_attributes(max_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { medium: max_valid_params }

          is_expected.to send_user_to(
            admin_medium_path(assigns(:medium))
          ).with_flash(:success, "admin.flash.media.success.create")
        end
      end

      context "with invalid params" do
        let(:invalid_params) { attributes_for(:minimal_medium).except(:name) }

        it "renders new" do
          post :create, params: { medium: invalid_params }

          is_expected.to successfully_render("admin/media/new")

          expect(assigns(:medium)).to have_coerced_attributes(invalid_params)
          expect(assigns(:medium)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      let(:medium) { create(:minimal_medium) }

      it "renders" do
        get :edit, params: { id: medium.to_param }

        is_expected.to successfully_render("admin/media/edit")
        is_expected.to assign(medium, :medium)
      end
    end

    describe "PUT #update" do
      let(:medium) { create(:minimal_medium) }

      let(:min_valid_params) { { name: "New Name" } }
      let(  :invalid_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested medium" do
          put :update, params: { id: medium.to_param, medium: min_valid_params }

          is_expected.to assign(medium, :medium).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: medium.to_param, medium: min_valid_params }

          is_expected.to send_user_to(
            admin_medium_path(assigns(:medium))
          ).with_flash(:success, "admin.flash.media.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: medium.to_param, medium: invalid_params }

          is_expected.to successfully_render("admin/media/edit")

          is_expected.to assign(medium, :medium).with_attributes(invalid_params).and_be_invalid
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:medium) { create(:minimal_medium) }

      it "destroys the requested medium" do
        expect {
          delete :destroy, params: { id: medium.to_param }
        }.to change(Medium, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: medium.to_param }

        is_expected.to send_user_to(admin_media_path).with_flash(
          :success, "admin.flash.media.success.destroy"
        )
      end
    end

    describe "POST #reorder_facets" do
      let(   :medium) { create(:minimal_medium, :with_facets) }
      let(:facet_ids) { medium.facets.map(&:id) }
      let( :shuffled) { facet_ids.shuffle }

      before(:each) do
        allow(medium).to receive(:reorder_facets!).and_call_original
      end

      context "non-xhr" do
        it "errors" do
          post :reorder_facets, params: { id: medium.to_param, facet_ids: shuffled }

          is_expected.to render_bad_request
        end
      end

      context "xhr" do
        it "reorders facets" do
          post :reorder_facets, xhr: true, params: { id: medium.to_param, facet_ids: shuffled }

          expect(response).to have_http_status(204)

          expect(medium.reload.facets.map(&:id)).to eq(shuffled)
        end
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
          "Name",
          "Viewable",
        ])
      end
    end
  end
end
