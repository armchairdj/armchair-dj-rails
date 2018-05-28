# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagsController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_tags_path }
    end
  end

  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context "All scope (default)" do
          it "renders" do
            get :index

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(0).of_total_records(0)
          end
        end

        context "For Posts scope" do
          it "renders" do
            get :index, params: { scope: "For Posts" }

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(0).of_total_records(0)
          end
        end

        context "For Works scope" do
          it "renders" do
            get :index, params: { scope: "For Works" }

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(0).of_total_records(0)
          end
        end

        context "Visible scope" do
          it "renders" do
            get :index, params: { scope: "Visible" }

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(0).of_total_records(0)
          end
        end

        context "Hidden scope" do
          it "renders" do
            get :index, params: { scope: "Hidden" }

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(0).of_total_records(0)
          end
        end
      end

      context "with records" do
        context "All scope (default)" do
          before(:each) do
            21.times { create(:minimal_tag) }
          end

          it "renders" do
            get :index

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            is_expected.to successfully_render("admin/tags/index")

            expect(assigns(:tags)).to paginate(1).of_total_records(21)
          end
        end

        pending "For Posts scope"
        pending "For Works scope"
        pending "Visible scope"
        pending "Hidden scope"
      end

      context "sorts" do
        pending "Name"
        pending "Category"
        pending "VPC"
        pending "NVPC"
      end
    end

    describe "GET #show" do
      let(:tag) { create(:minimal_tag) }

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

        expect(assigns(:categories)).to be_a_kind_of(ActiveRecord::Relation)
      end
    end

    describe "POST #create" do
      let(:max_valid_params) { attributes_for(:complete_tag) }
      let(:min_valid_params) { attributes_for(:minimal_tag) }
      let(  :invalid_params) { attributes_for(:minimal_tag).except(:name) }

      context "with min valid params" do
        it "creates a new Tag" do
          expect {
            post :create, params: { tag: min_valid_params }
          }.to change { Tag.count }.by(1)
        end

        it "creates the right attributes" do
          post :create, params: { tag: min_valid_params }

          is_expected.to assign(Tag.last, :tag).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { tag: min_valid_params }

          is_expected.to send_user_to(
            admin_tag_path(assigns(:tag))
          ).with_flash(:success, "admin.flash.tags.success.create")
        end
      end

      context "with max valid params" do
        it "creates a new Tag" do
          expect {
            post :create, params: { tag: max_valid_params }
          }.to change(Tag, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { tag: max_valid_params }

          is_expected.to assign(Tag.last, :tag).with_attributes(max_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { tag: max_valid_params }

          is_expected.to send_user_to(
            admin_tag_path(assigns(:tag))
          ).with_flash(:success, "admin.flash.tags.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { tag: invalid_params }

          is_expected.to successfully_render("admin/tags/new")

          expect(assigns(:tag)).to have_coerced_attributes(invalid_params)
          expect(assigns(:tag)).to be_invalid

          expect(assigns(:categories)).to be_a_kind_of(ActiveRecord::Relation)
        end
      end

      context "with multiple year tags" do
        pending "creates a range of years"
      end
    end

    describe "GET #edit" do
      let(:tag) { create(:minimal_tag) }

      it "renders" do
        get :edit, params: { id: tag.to_param }

        is_expected.to successfully_render("admin/tags/edit")
        is_expected.to assign(tag, :tag)

        expect(assigns(:categories)).to be_a_kind_of(ActiveRecord::Relation)
      end
    end

    describe "PUT #update" do
      let(:tag) { create(:minimal_tag) }

      let(:min_valid_params) { { name: "New Name" } }
      let(  :invalid_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested tag" do
          put :update, params: { id: tag.to_param, tag: min_valid_params }

          is_expected.to assign(tag, :tag).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: tag.to_param, tag: min_valid_params }

          is_expected.to send_user_to(
            admin_tag_path(assigns(:tag))
          ).with_flash(:success, "admin.flash.tags.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: tag.to_param, tag: invalid_params }

          is_expected.to successfully_render("admin/tags/edit")

          is_expected.to assign(tag, :tag).with_attributes(invalid_params).and_be_invalid

          expect(assigns(:categories)).to be_a_kind_of(ActiveRecord::Relation)
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
        expect(subject.keys).to eq([
          "All",
          "Visible",
          "Hidden",
          "For Posts",
          "For Works",
        ])
      end
    end

    pending "allowed_sorts"
  end
end
