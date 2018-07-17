# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::AspectsController, type: :controller do
  let(:aspect) { create(:minimal_aspect) }

  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      before(:each) { get :show, params: { id: aspect.to_param } }

      it { is_expected.to successfully_render("admin/aspects/show") }

      it { is_expected.to assign(aspect, :aspect) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { is_expected.to successfully_render("admin/aspects/new") }

      it { expect(assigns(:aspect)).to be_a_new(Aspect) }
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_aspect) }
      let(:bad_params) { attributes_for(:minimal_aspect).except(:name) }

      context "with min valid params" do
        subject { post :create, params: { aspect: min_params } }

        it { expect { subject }.to change(Aspect, :count).by(1) }

        it { is_expected.to assign(Aspect.last, :aspect).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_aspect_path(assigns(:aspect))) }

        it { is_expected.to have_flash(:success, "admin.flash.aspects.success.create") }
      end

      context "with invalid params" do
        let(:operation) { post :create, params: { aspect: bad_params } }

        subject { operation }

        it { is_expected.to successfully_render("admin/aspects/new") }

        describe "instance" do
          subject { operation; assigns(:aspect) }

          it { is_expected.to be_invalid }

          it { is_expected.to have_coerced_attributes(bad_params) }
        end
      end
    end

    describe "GET #edit" do
      before(:each) { get :edit, params: { id: aspect.to_param } }

      it { is_expected.to successfully_render("admin/aspects/edit") }

      it { is_expected.to assign(aspect, :aspect) }
    end

    describe "PUT #update" do
      let(    :update_params) { { name: "New Name" } }
      let(:bad_update_params) { { name: ""         } }

      context "with valid params" do
        before(:each) do
          put :update, params: { id: aspect.to_param, aspect: update_params }
        end

        it { is_expected.to assign(aspect, :aspect).with_attributes(update_params).and_be_valid }

        it { is_expected.to send_user_to(admin_aspect_path(assigns(:aspect))) }

        it { is_expected.to have_flash(:success, "admin.flash.aspects.success.update") }
      end

      context "with invalid params" do
        before(:each) do
          put :update, params: { id: aspect.to_param, aspect: bad_update_params }
        end

        it { is_expected.to successfully_render("admin/aspects/edit") }

        it { is_expected.to assign(aspect, :aspect).with_attributes(bad_update_params).and_be_invalid }
      end
    end

    describe "DELETE #destroy" do
      let!(:aspect) { create(:minimal_aspect) }

      subject { delete :destroy, params: { id: aspect.to_param } }

      it { expect { subject }.to change(Aspect, :count).by(-1) }

      it { is_expected.to send_user_to(admin_aspects_path) }

      it { is_expected.to have_flash(:success, "admin.flash.aspects.success.destroy") }
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
          "Facet",
          "ID",
          "Name",
        ])
      end
    end
  end
end
