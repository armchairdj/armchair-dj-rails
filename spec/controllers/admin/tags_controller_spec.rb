# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagsController do
  let(:tag) { create(:minimal_tag) }

  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  context "with root user" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index"
    end

    describe "GET #show" do
      subject { get :show, params: { id: tag.to_param } }

      it { is_expected.to successfully_render("admin/tags/show") }

      it { is_expected.to assign(tag, :tag) }
    end

    describe "GET #new" do
      subject(:send_request) { get :new }

      it { is_expected.to successfully_render("admin/tags/new") }

      it "assigns ivars" do
        send_request
        expect(assigns(:tag)).to be_a_new(Tag)
      end
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_tag) }
      let(:bad_params) { attributes_for(:minimal_tag).except(:name) }

      context "with min valid params" do
        subject(:send_request) { post :create, params: { tag: min_params } }

        it { expect { send_request }.to change(Tag, :count).by(1) }

        it { is_expected.to assign(Tag.last, :tag).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_tag_path(assigns(:tag))) }

        it { is_expected.to have_flash(:success, "admin.flash.tags.success.create") }
      end

      context "with invalid params" do
        let(:make_request) do
          post :create, params: { tag: bad_params }
        end

        it { expect(make_request).to successfully_render("admin/tags/new") }

        it "updates the object but assigns errors" do
          make_request

          actual = assigns(:tag)

          expect(actual).to have_coerced_attributes(bad_params)
          expect(actual).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      subject { get :edit, params: { id: tag.to_param } }

      it { is_expected.to successfully_render("admin/tags/edit") }

      it { is_expected.to assign(tag, :tag) }
    end

    describe "PUT #update" do
      let(:update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: "" } }

      context "with valid params" do
        subject do
          put :update, params: { id: tag.to_param, tag: update_params }
        end

        it { is_expected.to assign(tag, :tag).with_attributes(update_params).and_be_valid }

        it { is_expected.to send_user_to(admin_tag_path(assigns(:tag))) }

        it { is_expected.to have_flash(:success, "admin.flash.tags.success.update") }
      end

      context "with invalid params" do
        subject do
          put :update, params: { id: tag.to_param, tag: bad_update_params }
        end

        it { is_expected.to successfully_render("admin/tags/edit") }

        it { is_expected.to assign(tag, :tag).with_attributes(bad_update_params).and_be_invalid }
      end
    end

    describe "DELETE #destroy" do
      subject(:send_request) { delete :destroy, params: { id: tag.to_param } }

      let!(:tag) { create(:minimal_tag) }

      it { expect { send_request }.to change(Tag, :count).by(-1) }

      it { is_expected.to send_user_to(admin_tags_path) }

      it { is_expected.to have_flash(:success, "admin.flash.tags.success.destroy") }
    end
  end
end
