# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CreatorsController do
  let(:instance) { create_minimal_instance }

  it_behaves_like "a_paginatable_controller"

  context "with root user" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index"
    end

    describe "GET #show" do
      subject(:send_request) { get :show, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/creators/show") }

      it { is_expected.to assign(instance, :creator) }
    end

    describe "GET #new" do
      subject(:send_request) { get :new }

      it { is_expected.to successfully_render("admin/creators/new") }

      it { is_expected.to prepare_identity_and_membership_dropdowns }

      it "populates ivars" do
        send_request

        actual = assigns(:creator)

        expect(actual).to be_a_populated_new_creator
      end
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_creator) }
      let(:max_params) { attributes_for(:minimal_creator, :with_new_member, :with_new_pseudonym) }
      let(:alt_params) { attributes_for(:minimal_creator, :with_new_group,  :with_new_real_name) }
      let(:bad_params) { attributes_for(:minimal_creator).except(:name) }

      context "with min valid params" do
        subject(:send_request) { post :create, params: { creator: min_params } }

        it { expect { send_request }.to change(Creator, :count).by(1) }

        it { is_expected.to assign(Creator.last, :creator).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_creator_path(assigns(:creator))) }

        it { is_expected.to have_flash(:success, "admin.flash.creators.success.create") }
      end

      context "with max valid params including memeber and pseudonym" do
        subject(:send_request) { post :create, params: { creator: max_params } }

        it { expect { send_request }.to change(Creator,             :count).by(3) }
        it { expect { send_request }.to change(Creator::Identity,   :count).by(1) }
        it { expect { send_request }.to change(Creator::Membership, :count).by(1) }

        it { is_expected.to assign(Creator.last, :creator).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_creator_path(assigns(:creator))) }

        it { is_expected.to have_flash(:success, "admin.flash.creators.success.create") }
      end

      context "with max valid params including group and real_name" do
        subject(:send_request) { post :create, params: { creator: alt_params } }

        it { expect { send_request }.to change(Creator,             :count).by(3) }
        it { expect { send_request }.to change(Creator::Identity,   :count).by(1) }
        it { expect { send_request }.to change(Creator::Membership, :count).by(1) }

        it { is_expected.to assign(Creator.last, :creator).with_attributes(alt_params).and_be_valid }

        it { is_expected.to send_user_to(admin_creator_path(assigns(:creator))) }

        it { is_expected.to have_flash(:success, "admin.flash.creators.success.create") }
      end

      context "with invalid params" do
        subject(:send_request) { post :create, params: { creator: bad_params } }

        it { is_expected.to successfully_render("admin/creators/new") }

        it { is_expected.to prepare_identity_and_membership_dropdowns }

        it "populates ivars" do
          send_request

          actual = assigns(:creator)

          expect(actual).to be_a_populated_new_creator
          expect(actual).to have_coerced_attributes(bad_params)
        end
      end
    end

    describe "GET #edit" do
      subject(:send_request) { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/creators/edit") }

      it { is_expected.to assign(instance, :creator) }

      it { is_expected.to prepare_identity_and_membership_dropdowns }
    end

    describe "PUT #update" do
      let!(:instance) { create(:minimal_creator, :with_member, :with_pseudonym) }

      let(:bad_params) { { name: ""         } }
      let(:min_params) { { name: "New Name" } }
      let(:max_params) { attributes_for(:minimal_creator, :with_new_member, :with_new_pseudonym) }

      context "with min valid params" do
        subject(:send_request) do
          put :update, params: { id: instance.to_param, creator: min_params }
        end

        it { is_expected.to assign(instance, :creator).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_creator_path(assigns(:creator))) }

        it { is_expected.to have_flash(:success, "admin.flash.creators.success.update") }
      end

      context "with max valid params" do
        subject(:send_request) do
          put :update, params: { id: instance.to_param, creator: max_params }
        end

        it { expect { send_request }.to change(Creator::Identity,   :count).by(1) }

        it { expect { send_request }.to change(Creator::Membership, :count).by(1) }

        it { is_expected.to assign(instance, :creator).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_creator_path(assigns(:creator))) }

        it { is_expected.to have_flash(:success, "admin.flash.creators.success.update") }
      end

      context "with invalid params" do
        subject(:send_request) do
          put :update, params: { id: instance.to_param, creator: bad_params }
        end

        it { is_expected.to successfully_render("admin/creators/edit") }

        it { is_expected.to prepare_identity_and_membership_dropdowns }

        it "populates ivars" do
          send_request

          actual = assigns(:creator)

          expect(actual).to eq(instance)
          expect(actual).to be_invalid
        end
      end
    end

    describe "DELETE #destroy" do
      subject(:send_request) { delete :destroy, params: { id: instance.to_param } }

      let!(:instance) { create(:minimal_creator) }

      it { expect { send_request }.to change(Creator, :count).by(-1) }

      it { is_expected.to send_user_to(admin_creators_path) }

      it { is_expected.to have_flash(:success, "admin.flash.creators.success.destroy") }
    end
  end
end
