# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagsController, type: :controller do
  let(:tag) { create(:minimal_tag) }

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
        get :show, params: { id: tag.to_param }

        is_expected.to successfully_render("admin/tags/show")

        is_expected.to assign(tag, :tag)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/tags/new")

        expect(assigns(:tag)).to be_a_new(Tag)
      end
    end

    describe "POST #create" do
      let(:max_params) { attributes_for(:complete_tag) }
      let(:min_params) { attributes_for(:minimal_tag) }
      let(:bad_params) { attributes_for(:minimal_tag).except(:name) }

      context "with min valid params" do
        it "creates a new Tag" do
          expect {
            post :create, params: { tag: min_params }
          }.to change(Tag, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { tag: min_params }

          is_expected.to assign(Tag.last, :tag).with_attributes(min_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { tag: min_params }

          is_expected.to send_user_to(
            admin_tag_path(assigns(:tag))
          ).with_flash(:success, "admin.flash.tags.success.create")
        end
      end

      context "with max valid params" do
        it "creates a new Tag" do
          expect {
            post :create, params: { tag: max_params }
          }.to change(Tag, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { tag: max_params }

          is_expected.to assign(Tag.last, :tag).with_attributes(max_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { tag: max_params }

          is_expected.to send_user_to(
            admin_tag_path(assigns(:tag))
          ).with_flash(:success, "admin.flash.tags.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { tag: bad_params }

          is_expected.to successfully_render("admin/tags/new")

          expect(assigns(:tag)).to have_coerced_attributes(bad_params)
          expect(assigns(:tag)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      it "renders" do
        get :edit, params: { id: tag.to_param }

        is_expected.to successfully_render("admin/tags/edit")

        is_expected.to assign(tag, :tag)
      end
    end

    describe "PUT #update" do
      let(    :update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested tag" do
          put :update, params: { id: tag.to_param, tag: update_params }

          is_expected.to assign(tag, :tag).with_attributes(update_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: tag.to_param, tag: update_params }

          is_expected.to send_user_to(
            admin_tag_path(assigns(:tag))
          ).with_flash(:success, "admin.flash.tags.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: tag.to_param, tag: bad_update_params }

          is_expected.to successfully_render("admin/tags/edit")

          is_expected.to assign(tag, :tag).with_attributes(bad_update_params).and_be_invalid
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:tag) { create(:minimal_tag) }

      it "destroys the requested tag" do
        expect {
          delete :destroy, params: { id: tag.to_param }
        }.to change(Tag, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: tag.to_param }

        is_expected.to send_user_to(admin_tags_path).with_flash(
          :success, "admin.flash.tags.success.destroy"
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
          "ID",
          "Name",
        ])
      end
    end
  end
end
