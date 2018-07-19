# frozen_string_literal: true

RSpec.shared_examples "an_admin_post_controller" do
  let(:model_class) { described_class.controller_name.classify.constantize }
  let(  :view_path) { described_class.controller_name.to_sym }
  let(  :param_key) { model_class.model_name.param_key.to_sym }

  let(:templates) { {
    show: "admin/posts/#{view_path}/show",
    new:  "admin/posts/#{view_path}/new",
    edit: "admin/posts/#{view_path}/edit",
  } }

  def edit_path(instance)
    controller.send(:"edit_admin_#{param_key}_path", instance)
  end

  def show_path(instance)
    controller.send(:"admin_#{param_key}_path", instance)
  end

  def collection_path
    controller.send(:"admin_#{view_path}_path")
  end

  let(:min_create_params) { attributes_for_minimal_instance.except(:author_id) }
  let(:bad_create_params) { {} }
  let(:min_update_params) { attributes_for_minimal_instance.except(:author_id) }
  let(:max_update_params) { attributes_for_complete_instance.except(:author_id) }
  let(:reset_slug_params) { { "clear_slug" => "1" } }
  let(  :autosave_params) { { "body" => "autosaved", "summary" => "autosaved" } }

  def wrap_create_params(params)
    hash = {}
    hash[param_key] = params
    hash
  end

  def wrap_update_params(instance, params, step: nil)
    hash = { "id" => instance.to_param }

    hash[param_key.to_s] = params
    hash["step"        ] = step unless step.nil?

    hash
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let( :instance) { create_minimal_instance(:draft) }
      let(:operation) { get :show, params: { id: instance.to_param } }

      subject { operation }

      it { is_expected.to successfully_render(templates[:show]) }

      it { is_expected.to assign(instance, :post) }
    end

    describe "GET #new" do
      let(:operation) { get :new }

      subject { operation }

      it { is_expected.to successfully_render(templates[:new]) }

      describe "instance" do
        subject { operation; assigns(:post) }

        it { is_expected.to be_a_populated_new_post(param_key) }
      end
    end

    describe "POST #create" do
      let(:operation) { post :create, params: wrap_create_params(params) }

      subject { operation }

      context "success" do
        let(:params) { min_create_params }

        it { expect { subject }.to change(Post, :count).by(1) }

        it { is_expected.to send_user_to(edit_path(assigns(:post))) }

        it { is_expected.to have_flash(:success, "admin.flash.posts.success.create") }

        it { is_expected.to assign(Post.last, :post).with_attributes(params).and_be_valid }

        describe "instance" do
          subject { operation; Post.last }

          it { expect(subject.author).to eq(controller.current_user) }
        end
      end

      context "failure" do
        let(:params) { bad_create_params }

        it { is_expected.to successfully_render(templates[:new]) }

        describe "instance" do
          subject { operation; assigns(:post) }

          it { is_expected.to be_a_populated_new_post(param_key) }

          it { is_expected.to be_invalid }
        end
      end
    end

    describe "GET #edit" do
      let( :instance) { create_minimal_instance(:draft) }
      let(:operation) { get :edit, params: { id: instance.to_param } }

      subject { operation }

      it { is_expected.to successfully_render(templates[:edit]) }

      it { is_expected.to assign(instance, :post) }

      it { is_expected.to prepare_the_edit_post_form(param_key) }
    end

    describe "PUT #update" do
      context "draft" do
        let(:operation) { put :update, params: wrap_update_params(instance, params) }
        let( :instance) { create_minimal_instance(:draft) }

        subject { operation }

        context "with min valid params" do
          let(:params) { min_update_params }

          it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.update") }
        end

        context "with max valid params" do
          let(:params) { max_update_params }

          it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.update") }
        end

        context "with invalid params" do
          let(:params) { bad_update_params }

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to assign(instance, :post).with_attributes(params).and_be_invalid }

          it { is_expected.to prepare_the_edit_post_form(param_key) }
        end
      end

      context "published" do
        let(:operation) { put :update, params: wrap_update_params(instance, params) }
        let( :instance) { create_minimal_instance(:published) }

        subject { operation }

        context "replacing slug" do
          let(:params) { reset_slug_params }

          before(:each) { instance.update_column(:slug, "old_slug") }

          subject { operation; instance.reload.slugs }

          it "forces model to update slug" do
            is_expected.to_not eq("old_slug")
          end
        end
      end

      describe "status update operations" do
        subject { operation }

        describe "publishing" do
          let(:operation) { put :update, params: wrap_update_params(instance, params, step: "publish") }
          let( :instance) { create_minimal_instance(:draft) }

          context "with valid params" do
            let(:params) { max_update_params }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.publish") }

            describe "instance" do
              subject { operation; assigns(:post) }

              it { is_expected.to be_published }
            end
          end

          context "with failed transition" do
            let(:params) { max_update_params }

            before(:each) do
              allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)
            end

            it { is_expected.to successfully_render(templates[:edit]) }

            it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.publish") }

            it { is_expected.to prepare_the_edit_post_form(param_key) }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            describe "instance" do
              subject { operation; instance.reload }

              it { is_expected.to_not be_published }
            end
          end

          context "with invalid params" do
            let(:params) { bad_update_params }

            it { is_expected.to successfully_render(templates[:edit]) }

            it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.publish") }

            it { is_expected.to prepare_the_edit_post_form(param_key) }

            it { is_expected.to assign(instance, :post).with_attributes(params).with_errors(expected_publish_errors) }

            describe "instance" do
              subject { operation; instance.reload }

              it { is_expected.to_not be_published }
            end
          end
        end

        describe "unpublishing" do
          let(:operation) { put :update, params: wrap_update_params(instance, params, step: "unpublish") }
          let( :instance) { create_minimal_instance(:published) }

          context "with valid params" do
            let(:params) { max_update_params }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.unpublish") }

            describe "instance" do
              subject { operation; assigns(:post) }

              it { is_expected.to be_draft }
            end
          end

          context "with invalid params" do
            let(:params) { bad_update_params }

            it { is_expected.to successfully_render(templates[:edit]) }

            it { is_expected.to have_flash_now(:error, nil) }

            it { is_expected.to prepare_the_edit_post_form(param_key) }

            it { is_expected.to assign(instance, :post).with_attributes(params).with_errors(expected_unpublish_errors) }

            describe "instance" do
              subject { operation; assigns(:post) }

              it { is_expected.to be_draft }
            end
          end
        end

        describe "scheduling" do
          let(  :instance) { create_minimal_instance(:draft) }
          let(:all_params) { params.merge(publish_on: 3.weeks.from_now) }
          let( :operation) { put :update, params: wrap_update_params(instance, all_params, step: "schedule") }

          context "with valid params" do
            let(:params) { max_update_params }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.schedule") }

            describe "instance" do
              subject { operation; assigns(:post) }

              it { is_expected.to be_scheduled }
            end
          end

          context "with failed transition" do
            let(:params) { max_update_params }

            before(:each) do
              allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)
            end

            it { is_expected.to successfully_render(templates[:edit]) }

            it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.schedule") }

            it { is_expected.to prepare_the_edit_post_form(param_key) }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            describe "instance" do
              subject { operation; instance.reload }

              it { is_expected.to_not be_scheduled }
            end
          end

          context "with invalid params" do
            let(:params) { bad_update_params }

            it { is_expected.to successfully_render(templates[:edit]) }

            it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.schedule") }

            it { is_expected.to prepare_the_edit_post_form(param_key) }

            it { is_expected.to assign(instance, :post).with_attributes(params).with_errors(expected_publish_errors) }

            describe "instance" do
              subject { operation; instance.reload }

              it { is_expected.to_not be_scheduled }
            end
          end
        end

        describe "unscheduling" do
          let(:operation) { put :update, params: wrap_update_params(instance, params, step: "unschedule") }
          let( :instance) { create_minimal_instance(:scheduled) }

          context "with valid params" do
            let(:params) { max_update_params }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.unschedule") }

            describe "instance" do
              subject { operation; assigns(:post) }

              it { is_expected.to be_draft }
            end
          end

          context "with invalid params" do
            let(:params) { bad_update_params }

            it { is_expected.to successfully_render(templates[:edit]) }

            it { is_expected.to have_flash_now(:error, nil) }

            it { is_expected.to prepare_the_edit_post_form(param_key) }

            it { is_expected.to assign(instance, :post).with_attributes(params).with_errors(expected_unpublish_errors) }

            describe "instance" do
              subject { operation; assigns(:post) }

              it { is_expected.to be_draft }
            end
          end
        end
      end
    end

    describe "PUT #autosave" do
      let!(:instance) { create_minimal_instance(:draft) }
      let(:operation) { put :autosave, xhr: true, params: wrap_update_params(instance, params) }

      subject { operation }

      context "with valid params" do
        let(:params) { autosave_params }

        it { is_expected.to render_empty_json_200 }

        it { is_expected.to assign(instance, :post).with_attributes(params) }
      end

      context "with invalid params" do
        let(:params) { bad_update_params }

        it { is_expected.to render_empty_json_200 }

        it "saves without validating" do
          is_expected.to assign(instance, :post).with_attributes(params)
        end
      end

      context "with blacklisted params" do
        let(:params) { { "publish_on" => 3.weeks.from_now } }

        before(:each) { instance.update_column(:slug, "old_slug") }

        it { is_expected.to render_empty_json_200 }

        describe "cannot change status" do
          subject { operation; instance.reload } 

          it { is_expected.to_not be_scheduled }
        end
      end

      context "with failed save" do
        let(:params) { autosave_params }

        before(:each) do
          allow_any_instance_of(Post).to receive(:save!).and_raise(StandardError)
        end

        it { is_expected.to render_empty_json_500 }
      end

      context "non-xhr" do
        let(   :params) { autosave_params }
        let(:operation) { put :autosave, params: wrap_update_params(instance, params) }

        it { is_expected.to render_bad_request }
      end
    end

    describe "DELETE #destroy" do
      let!(:instance) { create_minimal_instance }
      let(:operation) { delete :destroy, params: { id: instance.to_param } }

      subject { operation }

      it { expect{ subject }.to change(Post, :count).by(-1) }

      it { is_expected.to send_user_to(collection_path) }

      it { is_expected.to have_flash(:success, "admin.flash.posts.success.destroy") }
    end
  end

  context "as admin" do
    pending "cannot destroy"
  end

  context "as editor" do
    pending "cannot destroy"
    pending "cannot publish"
  end

  context "as writer" do
    pending "cannot destroy"
    pending "cannot publish"
    pending "cannot access others' posts"
  end

  describe "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([
          "All",
          "Draft",
          "Scheduled",
          "Published",
        ])
      end
    end
  end
end
