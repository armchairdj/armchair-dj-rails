# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::AspectsController, type: :controller do
  let(:aspect) { create(:minimal_aspect) }

  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      it "renders" do
        get :show, params: { id: aspect.to_param }

        is_expected.to successfully_render("admin/aspects/show")

        is_expected.to assign(aspect, :aspect)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/aspects/new")

        expect(assigns(:aspect)).to be_a_new(Aspect)
      end
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_aspect) }
      let(:bad_params) { attributes_for(:minimal_aspect).except(:name) }

      context "with min valid params" do
        it "creates a new Aspect" do
          expect {
            post :create, params: { aspect: min_params }
          }.to change(Aspect, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { aspect: min_params }

          is_expected.to assign(Aspect.last, :aspect).with_attributes(min_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { aspect: min_params }

          is_expected.to send_user_to(
            admin_aspect_path(assigns(:aspect))
          ).with_flash(:success, "admin.flash.aspects.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { aspect: bad_params }

          is_expected.to successfully_render("admin/aspects/new")

          expect(assigns(:aspect)).to have_coerced_attributes(bad_params)
          expect(assigns(:aspect)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      it "renders" do
        get :edit, params: { id: aspect.to_param }

        is_expected.to successfully_render("admin/aspects/edit")

        is_expected.to assign(aspect, :aspect)
      end
    end

    describe "PUT #update" do
      let(    :update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested aspect" do
          put :update, params: { id: aspect.to_param, aspect: update_params }

          is_expected.to assign(aspect, :aspect).with_attributes(update_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: aspect.to_param, aspect: update_params }

          is_expected.to send_user_to(
            admin_aspect_path(assigns(:aspect))
          ).with_flash(:success, "admin.flash.aspects.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: aspect.to_param, aspect: bad_update_params }

          is_expected.to successfully_render("admin/aspects/edit")

          is_expected.to assign(aspect, :aspect).with_attributes(bad_update_params).and_be_invalid
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:aspect) { create(:minimal_aspect) }

      it "destroys the requested aspect" do
        expect {
          delete :destroy, params: { id: aspect.to_param }
        }.to change(Aspect, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: aspect.to_param }

        is_expected.to send_user_to(admin_aspects_path).with_flash(
          :success, "admin.flash.aspects.success.destroy"
        )
      end
    end
  end

  context "helpers" do
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
          "Facet",
          "ID",
          "Name",
        ])
      end
    end
  end
end
