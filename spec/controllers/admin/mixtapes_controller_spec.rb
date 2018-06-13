# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MixtapesController, type: :controller do
  let(:summary) { "summary summary summary summary summary." }

  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_linkable_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_mixtapes_path }
    end
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      context "standalone" do
        let(:mixtape) { create(:minimal_mixtape) }

        it "renders" do
          get :show, params: { id: mixtape.to_param }

          is_expected.to successfully_render("admin/mixtapes/show")
          is_expected.to assign(mixtape, :mixtape)
        end
      end

      context "mixtape" do
        let(:mixtape) { create(:minimal_mixtape) }

        it "renders" do
          get :show, params: { id: mixtape.to_param }

          is_expected.to successfully_render("admin/mixtapes/show")
          is_expected.to assign(mixtape, :mixtape)
        end
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/mixtapes/new")

        is_expected.to define_all_tabs.and_select("mixtape-choose-work")

        expect(assigns(:mixtape)).to be_a_populated_new_mixtape
      end
    end

    describe "POST #create" do
      context "standalone" do
        let(:max_params) { attributes_for(:complete_mixtape).except(:author_id) }
        let(:min_params) { attributes_for(:minimal_mixtape ).except(:author_id) }
        let(  :bad_params) { attributes_for(:minimal_mixtape ).except(:author_id, :play_list_id) }

        context "with max valid params" do
          it "creates a new Mixtape" do
            expect {
              post :create, params: { mixtape: max_params }
            }.to change(Mixtape, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { mixtape: max_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(max_params).and_be_valid
          end

          it "mixtape belongs to current_user" do
            post :create, params: { mixtape: max_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(author: controller.current_user)
          end

          it "redirects to mixtape" do
            post :create, params: { mixtape: max_params }

            is_expected.to send_user_to(
              admin_mixtape_path(assigns(:mixtape))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with min valid params" do
          it "creates a new Mixtape" do
            expect {
              post :create, params: { mixtape: min_params }
            }.to change(Mixtape, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(min_params).and_be_valid
          end

          it "mixtape belongs to current_user" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(author: controller.current_user)
          end

          it "redirects to mixtape" do
            post :create, params: { mixtape: min_params }

            is_expected.to send_user_to(
              admin_mixtape_path(assigns(:mixtape))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { mixtape: bad_params }

            is_expected.to successfully_render("admin/mixtapes/new")

            is_expected.to define_all_tabs.and_select("mixtape-choose-work")

            expect(assigns(:mixtape)).to be_a_populated_new_mixtape
            expect(assigns(:mixtape)).to have_coerced_attributes(bad_params)
            expect(assigns(:mixtape)).to be_invalid
          end
        end
      end

      context "existing work" do
        let(:max_params) { attributes_for(:complete_mixtape).except(:author_id) }
        let(:min_params) { attributes_for(:minimal_mixtape ).except(:author_id) }
        let(  :bad_params) { attributes_for(:minimal_mixtape ).except(:author_id, :play_list_id) }

        context "with max valid params" do
          it "creates a new Mixtape" do
            expect {
              post :create, params: { mixtape: max_params }
            }.to change(Mixtape, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { mixtape: max_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(max_params).and_be_valid
          end

          it "mixtape belongs to current_user" do
            post :create, params: { mixtape: max_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(author: controller.current_user)
          end

          it "redirects to mixtape" do
            post :create, params: { mixtape: max_params }

            is_expected.to send_user_to(
              admin_mixtape_path(assigns(:mixtape))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with min valid params" do
          it "creates a new Mixtape" do
            expect {
              post :create, params: { mixtape: min_params }
            }.to change(Mixtape, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(min_params).and_be_valid
          end

          it "mixtape belongs to current_user" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(author: controller.current_user)
          end

          it "redirects to mixtape" do
            post :create, params: { mixtape: min_params }

            is_expected.to send_user_to(
              admin_mixtape_path(assigns(:mixtape))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { mixtape: bad_params }

            is_expected.to successfully_render("admin/mixtapes/new")

            is_expected.to define_all_tabs.and_select("mixtape-choose-work")

            expect(assigns(:mixtape)).to be_a_populated_new_mixtape
            expect(assigns(:mixtape)).to have_coerced_attributes(bad_params)
            expect(assigns(:mixtape)).to be_invalid
          end
        end
      end

      context "new work" do
        let(:max_params) { attributes_for(:complete_mixtape_with_new_work).except(:author_id).deep_stringify_keys }
        let(:min_params) { attributes_for(         :mixtape_with_new_work).except(:author_id).deep_stringify_keys }
        let(  :bad_params) { attributes_for( :invalid_mixtape_with_new_work).except(:author_id).deep_stringify_keys }

        context "with max valid params" do
          it "creates a new Mixtape" do
            post :create, params: { mixtape: max_params }

            expect {
              post :create, params: { mixtape: max_params }
            }.to change(Mixtape, :count).by(1)
          end

          it "creates a new Work" do
            expect {
              post :create, params: { mixtape: max_params }
            }.to change(Work, :count).by(1)
          end

          it "creates new Credits" do
            expect {
              post :create, params: { mixtape: max_params }
            }.to change(Credit, :count).by(3)
          end

          it "creates the right attributes" do
            post :create, params: { mixtape: max_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(max_params).and_be_valid
          end

          it "mixtape belongs to current_user" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(author: controller.current_user)
          end

          it "redirects to mixtape" do
            post :create, params: { mixtape: min_params }

            is_expected.to send_user_to(
              admin_mixtape_path(assigns(:mixtape))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with min valid params" do
          it "creates a new Mixtape" do
            expect {
              post :create, params: { mixtape: min_params }
            }.to change(Mixtape, :count).by(1)
          end

          it "creates a new Work" do
            expect {
              post :create, params: { mixtape: min_params }
            }.to change(Work, :count).by(1)
          end

          it "creates new Credits" do
            expect {
              post :create, params: { mixtape: min_params }
            }.to change(Credit, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(min_params).and_be_valid
          end

          it "mixtape belongs to current_user" do
            post :create, params: { mixtape: min_params }

            is_expected.to assign(Mixtape.last, :mixtape).with_attributes(author: controller.current_user)
          end

          it "redirects to mixtape" do
            post :create, params: { mixtape: min_params }

            is_expected.to send_user_to(
              admin_mixtape_path(assigns(:mixtape))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { mixtape: bad_params }

            is_expected.to successfully_render("admin/mixtapes/new")

            is_expected.to define_all_tabs.and_select("mixtape-new-work")

            expect(assigns(:mixtape)).to be_a_populated_new_mixtape
            expect(assigns(:mixtape)).to have_coerced_attributes(bad_params)
            expect(assigns(:mixtape)).to be_invalid
          end
        end
      end
    end

    describe "GET #edit" do
      context "standalone" do
        let(:mixtape) { create(:minimal_mixtape) }

        it "renders" do
          get :edit, params: { id: mixtape.to_param }

          is_expected.to successfully_render("admin/mixtapes/edit")
          is_expected.to assign(mixtape, :mixtape)

          is_expected.to define_only_the_standalone_tab
        end
      end

      context "mixtape" do
        let(:mixtape) { create(:minimal_mixtape) }

        it "renders" do
          get :edit, params: { id: mixtape.to_param }

          is_expected.to successfully_render("admin/mixtapes/edit")
          is_expected.to assign(mixtape, :mixtape)

          is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")
        end
      end
    end

    describe "PUT #update" do
      context "draft" do
        context "standalone" do
          let(:mixtape) { create(:minimal_mixtape) }

          let(:min_params) { { "title" => "New Title" } }
          let(  :bad_params) { { "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { id: mixtape.to_param, mixtape: min_params }
            end

            it "updates the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.update"
            ) }
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit")
              is_expected.to assign(mixtape, :mixtape)

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).and_be_invalid

              is_expected.to define_only_the_standalone_tab
            end
          end
        end

        context "mixtape" do
          let(:mixtape) { create(:minimal_mixtape) }

          let(:min_params) { { "work_id" => create(:minimal_song).id } }
          let(  :bad_params) { { "work_id" => ""                       } }

          context "with valid params" do
            before(:each) do
              put :update, params: { id: mixtape.to_param, mixtape: min_params }
            end

            it "updates the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.update"
            ) }
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit")

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).and_be_invalid

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")
            end
          end
        end

        describe "replacing work with new work" do
          let!(:mixtape) { create(:minimal_mixtape) }

          let(:min_params) { attributes_for(        :mixtape_with_new_work).except(:author_id).merge(work_id: mixtape.work_id).deep_stringify_keys }
          let(  :bad_params) { attributes_for(:invalid_mixtape_with_new_work).except(:author_id).merge(work_id: mixtape.work_id).deep_stringify_keys }

          context "with valid params" do
            it "updates the requested mixtape, ignoring work_id in favor of work_attributes" do
              expect {
                put :update, params: { id: mixtape.to_param, mixtape: min_params }
              }.to change { Work.count }.by(1)

              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params.except("work_id")).and_be_valid
            end

            specify do
              put :update, params: { id: mixtape.to_param, mixtape: min_params }

              is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
                :success, "admin.flash.posts.success.update"
              )
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit")

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params.except("work_id")).and_be_invalid

              expect(assigns(:mixtape).work).to be_a_new(Work)
              expect(assigns(:mixtape).work).to be_invalid

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-new-work")
            end
          end
        end
      end

      pending "replacing slug"

      context "publishing" do
        context "standalone" do
          let(:mixtape) { create(:minimal_mixtape, :draft) }

          let(:min_params) { { "body" => "New body.", "title" => "New title." } }
          let(  :bad_params) { { "body" => ""         , "title" => ""           } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "publish", id: mixtape.to_param, mixtape: min_params }
            end

            it "updates and publishes the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_published
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.publish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Mixtape).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates mixtape and renders edit with message" do
              put :update, params: { step: "publish", id: mixtape.to_param, mixtape: min_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(mixtape.reload).to_not be_published
            end
          end

          context "with invalid params" do
            it "fails to publish and renders edit with message and errors" do
              put :update, params: { step: "publish", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                body:  :blank,
                title: :blank
              })

              expect(mixtape.reload).to_not be_published
            end
          end
        end

        context "mixtape" do
          let(:mixtape) { create(:minimal_mixtape, :draft) }

          let(:min_params) { { "body" => "New body.", "work_id" => create(:minimal_song).id } }
          let(  :bad_params) { { "body" => ""         , "work_id" => ""               } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "publish", id: mixtape.to_param, mixtape: min_params }
            end

            it "updates and publishes the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_published
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.publish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Mixtape).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates mixtape and renders edit with message" do
              put :update, params: { step: "publish", id: mixtape.to_param, mixtape: min_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")

              is_expected.to assign(mixtape, :mixtape).with_attributes({
                body:            min_params["body"   ],
                current_work_id: min_params["work_id"]
              })

              expect(mixtape.reload).to_not be_published
            end
          end

          context "with invalid params" do
            it "fails to publish and renders edit with message and errors" do
              put :update, params: { step: "publish", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                body:    :blank,
                work_id: :blank
              })

              expect(mixtape.reload).to_not be_published
            end
          end
        end
      end

      context "unpublishing" do
        context "standalone" do
          let(:mixtape) { create(:minimal_mixtape, :published) }

          let(:min_params) { { "body" => "", "title" => "New title."} }
          let(  :bad_params) { { "body" => "", "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unpublish", id: mixtape.to_param, mixtape: min_params }
            end

            it "unpublishes and updates the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_draft
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.unpublish"
            ) }
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(:error, nil)

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                title: :blank
              })

              expect(assigns(:mixtape)).to be_draft
            end
          end
        end

        context "mixtape" do
          let(:mixtape) { create(:minimal_mixtape, :published) }

          let(:min_params) { { "body" => "", "work_id" => create(:minimal_song).id } }
          let(  :bad_params) { { "body" => "", "work_id" => ""                       } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unpublish", id: mixtape.to_param, mixtape: min_params }
            end

            it "unpublishes and updates the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_draft
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.unpublish"
            ) }
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(:error, nil)

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                work_id: :blank
              })

              expect(assigns(:mixtape)).to be_draft
            end
          end
        end
      end

      context "scheduling" do
        context "standalone" do
          let(:mixtape) { create(:minimal_mixtape, :draft) }

          let(:min_params) { { "body" => "New body.", "title" => "New title.", publish_on: "01/01/2050" } }
          let(  :bad_params) { { "body" => "",          "title" => ""                                     } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: min_params }
            end

            it "updates and schedules the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_scheduled
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.schedule"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Mixtape).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates mixtape and renders edit with message" do
              put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: min_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(mixtape.reload).to_not be_scheduled
            end
          end

          context "with invalid params" do
            it "fails to schedule and renders edit with message and errors" do
              put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                body:  :blank,
                title: :blank
              })

              expect(mixtape.reload).to_not be_scheduled
            end
          end
        end

        context "mixtape" do
          let(:mixtape) { create(:minimal_mixtape) }

          let(:min_params) { { "body" => "New body.", "work_id" => create(:minimal_song).id, publish_on: "01/01/2050" } }
          let(  :bad_params) { { "body" => ""         , "work_id" => ""                                                 } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: min_params }
            end

            it "updates and schedules the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_scheduled
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.schedule"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Mixtape).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates mixtape and renders edit with message" do
              put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: min_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")

              is_expected.to assign(mixtape, :mixtape).with_attributes({
                body:            min_params["body"   ],
                current_work_id: min_params["work_id"]
              })

              expect(mixtape.reload).to_not be_scheduled
            end
          end

          context "with invalid params" do
            it "fails to schedule and renders edit with message and errors" do
              put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                body:    :blank,
                work_id: :blank
              })

              expect(mixtape.reload).to_not be_scheduled
            end
          end
        end
      end

      context "unscheduling" do
        context "standalone" do
          let(:mixtape) { create(:minimal_mixtape, :scheduled) }

          let(:min_params) { { "body" => "", "title" => "New title."} }
          let(  :bad_params) { { "body" => "", "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unschedule", id: mixtape.to_param, mixtape: min_params }
            end

            it "unschedules and updates the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_draft
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.unschedule"
            ) }
          end

          context "with invalid params" do
            it "unschedules and renders edit with errors" do
              put :update, params: { step: "unschedule", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(:error, nil)

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                title: :blank
              })

              expect(assigns(:mixtape)).to be_draft
            end
          end
        end

        context "mixtape" do
          let(:mixtape) { create(:minimal_mixtape, :scheduled) }

          let(:min_params) { { "body" => "", "work_id" => create(:minimal_song).id } }
          let(  :bad_params) { { "body" => "", "work_id" => ""                       } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unschedule", id: mixtape.to_param, mixtape: min_params }
            end

            it "unschedules and updates the requested mixtape" do
              is_expected.to assign(mixtape, :mixtape).with_attributes(min_params).and_be_valid

              expect(assigns(:mixtape)).to be_draft
            end

            it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
              :success, "admin.flash.posts.success.unschedule"
            ) }
          end

          context "with invalid params" do
            it "unschedules and renders edit with errors" do
              put :update, params: { step: "unschedule", id: mixtape.to_param, mixtape: bad_params }

              is_expected.to successfully_render("admin/mixtapes/edit").with_flash(:error, nil)

              is_expected.to define_only_the_mixtape_tabs.and_select("mixtape-choose-work")

              is_expected.to assign(mixtape, :mixtape).with_attributes(bad_params).with_errors({
                work_id: :blank
              })

              expect(assigns(:mixtape)).to be_draft
            end
          end
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:mixtape) { create(:minimal_mixtape) }

      it "destroys the requested mixtape" do
        expect {
          delete :destroy, params: { id: mixtape.to_param }
        }.to change(Mixtape, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: mixtape.to_param }

        is_expected.to send_user_to(admin_mixtapes_path).with_flash(
          :success, "admin.flash.posts.success.destroy"
        )
      end
    end
  end

  context "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([
          "Draft",
          "Scheduled",
          "Published",
          "Review",
          "Mixtape",
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
          "Title",
          "Author",
          "Type",
          "Status",
        ])
      end
    end
  end
end
