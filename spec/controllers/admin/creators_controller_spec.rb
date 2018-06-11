# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CreatorsController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_linkable_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_creators_path }
    end
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let(:creator) { create(:minimal_creator) }

      it "renders" do
        get :show, params: { id: creator.to_param }

        is_expected.to successfully_render("admin/creators/show")
        is_expected.to assign(creator, :creator)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/creators/new")

        expect(assigns(:creator)).to be_a_populated_new_creator

        is_expected.to prepare_identity_and_membership_dropdowns
      end
    end

    describe "POST #create" do
      let(    :max_params) { attributes_for(:minimal_creator, :with_summary, :with_new_member, :with_new_pseudonym) }
      let(:alt_max_params) { attributes_for(:minimal_creator, :with_summary, :with_new_group,  :with_new_real_name) }
      let(  :valid_params) { attributes_for(:minimal_creator) }
      let(:invalid_params) { attributes_for(:minimal_creator).except(:name) }

      context "with max valid params including memeber and pseudonym" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: max_params }
          }.to change(Creator, :count).by(3)
        end

        it "creates a new Identity" do
          expect {
            post :create, params: { creator: max_params }
          }.to change(Identity, :count).by(1)
        end

        it "creates a new Membership" do
          expect {
            post :create, params: { creator: max_params }
          }.to change(Membership, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { creator: max_params }

          is_expected.to assign(Creator.last, :creator).with_attributes(max_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { creator: max_params }

          is_expected.to send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.create")
        end
      end

      context "with max valid params including group and real_name" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: alt_max_params }
          }.to change(Creator, :count).by(3)
        end

        it "creates a new Identity" do
          expect {
            post :create, params: { creator: alt_max_params }
          }.to change(Identity, :count).by(1)
        end

        it "creates a new Membership" do
          expect {
            post :create, params: { creator: alt_max_params }
          }.to change(Membership, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { creator: alt_max_params }

          is_expected.to assign(Creator.last, :creator).with_attributes(alt_max_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { creator: alt_max_params }

          is_expected.to send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.create")
        end
      end

      context "with min valid params" do
        it "creates a new Creator" do
          expect {
            post :create, params: { creator: valid_params }
          }.to change(Creator, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { creator: valid_params }

          is_expected.to assign(Creator.last, :creator).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { creator: valid_params }

          is_expected.to send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { creator: invalid_params }

          is_expected.to successfully_render("admin/creators/new")

          expect(assigns(:creator)).to be_a_populated_new_creator
          expect(assigns(:creator)).to have_coerced_attributes(invalid_params)

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end
    end

    describe "GET #edit" do
      context "plain jane" do
        let!(:creator) { create(:minimal_creator) }

        it "renders" do
          get :edit, params: { id: creator.to_param }

          is_expected.to successfully_render("admin/creators/edit")
          is_expected.to assign(creator, :creator)

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end

      context "with group" do
        let!(:creator) { create(:minimal_creator, :with_group) }

        it "renders" do
          get :edit, params: { id: creator.to_param }

          expect(assigns(:creator).group_memberships).to have(6).items

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end

      context "with member" do
        let!(:creator) { create(:minimal_creator, :with_member) }

        it "renders" do
          get :edit, params: { id: creator.to_param }

          expect(assigns(:creator).member_memberships).to have(6).items

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end

      context "with pseudonym" do
        let!(:creator) { create(:minimal_creator, :with_pseudonym) }

        it "renders" do
          get :edit, params: { id: creator.to_param }

          expect(assigns(:creator).pseudonym_identities).to have(6).items

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end

      context "with real_name" do
        let!(:creator) { create(:minimal_creator, :with_real_name) }

        it "renders" do
          get :edit, params: { id: creator.to_param }

          expect(assigns(:creator).real_name_identities).to have(1).items

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end
    end

    describe "PUT #update" do
      let!(:creator) { create(:minimal_creator, :with_member, :with_pseudonym) }

      let(    :max_params) { attributes_for(:creator, :with_summary, :with_new_member, :with_new_pseudonym) }
      let(:ignored_params) { attributes_for(:creator, :with_summary, :with_new_group,  :with_new_real_name) }

      let(  :valid_params) { { name: "New Name" } }
      let(:invalid_params) { { name: ""         } }

      context "with max valid params" do
        it "updates the requested creator" do
          put :update, params: { id: creator.to_param, creator: max_params }

          is_expected.to assign(creator, :creator).with_attributes(max_params).and_be_valid
        end

        it "creates a new Identity" do
          expect {
            put :update, params: { id: creator.to_param, creator: max_params }
          }.to change(Identity, :count).by(1)
        end

        it "creates a new Membership" do
          expect {
            put :update, params: { id: creator.to_param, creator: max_params }
          }.to change(Membership, :count).by(1)
        end

        it "redirects to index" do
          put :update, params: { id: creator.to_param, creator: max_params }

          is_expected.to send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.update")
        end
      end

      context "with ignored max params" do
        it "updates the requested creator" do
          put :update, params: { id: creator.to_param, creator: ignored_params }

          is_expected.to assign(creator, :creator).with_attributes(ignored_params.slice(:creator)).and_be_valid
        end

        it "silently ignores the requested real name since this is a primary creator" do
          expect {
            put :update, params: { id: creator.to_param, creator: ignored_params }
          }.to_not change(Identity, :count)
        end

        it "silently ignores the reuqested new group since this is a collective creator" do
          expect {
            put :update, params: { id: creator.to_param, creator: ignored_params }
          }.to_not change(Membership, :count)
        end

        it "redirects to index" do
          put :update, params: { id: creator.to_param, creator: ignored_params }

          is_expected.to send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.update")
        end
      end

      context "with min valid params" do
        it "updates the requested creator" do
          put :update, params: { id: creator.to_param, creator: valid_params }

          is_expected.to assign(creator, :creator).with_attributes(valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: creator.to_param, creator: valid_params }

          is_expected.to send_user_to(
            admin_creator_path(assigns(:creator))
          ).with_flash(:success, "admin.flash.creators.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: creator.to_param, creator: invalid_params }

          is_expected.to successfully_render("admin/creators/edit")

          expect(assigns(:creator)       ).to eq(creator)
          expect(assigns(:creator).valid?).to eq(false)

          is_expected.to prepare_identity_and_membership_dropdowns
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:creator) { create(:minimal_creator) }

      it "destroys the requested creator" do
        expect {
          delete :destroy, params: { id: creator.to_param }
        }.to change(Creator, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: creator.to_param }

        is_expected.to send_user_to(
          admin_creators_path
        ).with_flash(:success, "admin.flash.creators.success.destroy")
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
          "Primary",
          "Individual",
          "Viewable",
        ])
      end
    end
  end
end
