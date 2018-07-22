# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagsController, type: :controller do
  let(:tag) { create(:minimal_tag) }

  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      # it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      subject { get :show, params: { id: tag.to_param } }

      it { is_expected.to successfully_render("admin/tags/show") }

      it { is_expected.to assign(tag, :tag) }
    end

    describe "GET #new" do
      subject { get :new }

      it { is_expected.to successfully_render("admin/tags/new") }

      it { subject; expect(assigns(:tag)).to be_a_new(Tag) }
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_tag) }
      let(:bad_params) { attributes_for(:minimal_tag).except(:name) }

      context "with min valid params" do
        subject { post :create, params: { tag: min_params } }

        it { expect { subject }.to change(Tag, :count).by(1) }

        it { is_expected.to assign(Tag.last, :tag).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_tag_path(assigns(:tag))) }

        it { is_expected.to have_flash(:success, "admin.flash.tags.success.create") }
      end

      context "with invalid params" do
        subject { post :create, params: { tag: bad_params } }

        it { is_expected.to successfully_render("admin/tags/new") }

        it { subject; expect(assigns(:tag)).to have_coerced_attributes(bad_params) }
        it { subject; expect(assigns(:tag)).to be_invalid }
      end
    end

    describe "GET #edit" do
      subject { get :edit, params: { id: tag.to_param } }

      it { is_expected.to successfully_render("admin/tags/edit") }

      it { is_expected.to assign(tag, :tag) }
    end

    describe "PUT #update" do
      let(    :update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: ""         } }

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
      let!(:tag) { create(:minimal_tag) }

      subject { delete :destroy, params: { id: tag.to_param } }

      it { expect { subject }.to change(Tag, :count).by(-1) }

      it { is_expected.to send_user_to(admin_tags_path) }

      it { is_expected.to have_flash(:success, "admin.flash.tags.success.destroy") }
    end
  end

  describe "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Name",
        ])
      end
    end
  end
end
