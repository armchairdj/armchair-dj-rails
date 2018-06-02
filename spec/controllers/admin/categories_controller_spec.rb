# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_categories_path }
    end
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let(:category) { create(:minimal_category) }

      it "renders" do
        get :show, params: { id: category.to_param }

        is_expected.to successfully_render("admin/categories/show")
        is_expected.to assign(category, :category)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/categories/new")

        expect(assigns(:category)).to be_a_new(Category)
      end
    end

    describe "POST #create" do
      let(:max_valid_params) { attributes_for(:complete_category) }
      let(:min_valid_params) { attributes_for(:minimal_category) }
      let(  :invalid_params) { attributes_for(:minimal_category).except(:name) }

      context "with min valid params" do
        it "creates a new Category" do
          expect {
            post :create, params: { category: min_valid_params }
          }.to change(Category, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { category: min_valid_params }

          is_expected.to assign(Category.last, :category).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { category: min_valid_params }

          is_expected.to send_user_to(
            admin_category_path(assigns(:category))
          ).with_flash(:success, "admin.flash.categories.success.create")
        end
      end

      context "with max valid params" do
        it "creates a new Category" do
          expect {
            post :create, params: { category: max_valid_params }
          }.to change(Category, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { category: max_valid_params }

          is_expected.to assign(Category.last, :category).with_attributes(max_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { category: max_valid_params }

          is_expected.to send_user_to(
            admin_category_path(assigns(:category))
          ).with_flash(:success, "admin.flash.categories.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { category: invalid_params }

          is_expected.to successfully_render("admin/categories/new")

          expect(assigns(:category)).to have_coerced_attributes(invalid_params)
          expect(assigns(:category)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      let(:category) { create(:minimal_category) }

      it "renders" do
        get :edit, params: { id: category.to_param }

        is_expected.to successfully_render("admin/categories/edit")
        is_expected.to assign(category, :category)
      end
    end

    describe "PUT #update" do
      let(:category) { create(:minimal_category) }

      let(:min_valid_params) { { name: "New Name" } }
      let(  :invalid_params) { { name: ""         } }

      context "with valid params" do
        it "updates the requested category" do
          put :update, params: { id: category.to_param, category: min_valid_params }

          is_expected.to assign(category, :category).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: category.to_param, category: min_valid_params }

          is_expected.to send_user_to(
            admin_category_path(assigns(:category))
          ).with_flash(:success, "admin.flash.categories.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: category.to_param, category: invalid_params }

          is_expected.to successfully_render("admin/categories/edit")

          is_expected.to assign(category, :category).with_attributes(invalid_params).and_be_invalid
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:category) { create(:minimal_category) }

      it "destroys the requested category" do
        expect {
          delete :destroy, params: { id: category.to_param }
        }.to change(Category, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: category.to_param }

        is_expected.to send_user_to(admin_categories_path).with_flash(
          :success, "admin.flash.categories.success.destroy"
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
          "String",
          "Year",
          "Multi",
          "Single",
        ])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "Name",
          "Format",
          "Multi?",
        ])
      end
    end
  end
end
