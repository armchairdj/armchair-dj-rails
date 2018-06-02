# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PostsController, type: :controller do
  let(:summary) { "summary summary summary summary summary." }

  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_linkable_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_posts_path }
    end
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      context "standalone" do
        let(:post) { create(:standalone_post) }

        it "renders" do
          get :show, params: { id: post.to_param }

          is_expected.to successfully_render("admin/posts/show")
          is_expected.to assign(post, :post)
        end
      end

      context "review" do
        let(:post) { create(:review) }

        it "renders" do
          get :show, params: { id: post.to_param }

          is_expected.to successfully_render("admin/posts/show")
          is_expected.to assign(post, :post)
        end
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/posts/new")

        is_expected.to define_all_tabs.and_select("post-choose-work")

        expect(assigns(:post)).to be_a_populated_new_post
      end
    end

    describe "POST #create" do
      context "standalone" do
        let(:max_valid_params) { attributes_for(:complete_standalone_post).except(:author_id) }
        let(:min_valid_params) { attributes_for(:standalone_post         ).except(:author_id) }
        let(  :invalid_params) { attributes_for(:post, :with_body        ).except(:author_id) }

        context "with max valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: max_valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { post: max_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(max_valid_params).and_be_valid
          end

          it "post belongs to current_user" do
            post :create, params: { post: max_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(author: controller.current_user)
          end

          it "redirects to post" do
            post :create, params: { post: max_valid_params }

            is_expected.to send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with min valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: min_valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(min_valid_params).and_be_valid
          end

          it "post belongs to current_user" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(author: controller.current_user)
          end

          it "redirects to post" do
            post :create, params: { post: min_valid_params }

            is_expected.to send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            is_expected.to successfully_render("admin/posts/new")

            is_expected.to define_all_tabs.and_select("post-choose-work")

            expect(assigns(:post)).to be_a_populated_new_post
            expect(assigns(:post)).to have_coerced_attributes(invalid_params)
            expect(assigns(:post)).to be_invalid
          end
        end
      end

      context "existing work" do
        let(:max_valid_params) { attributes_for(:complete_review ).except(:author_id) }
        let(:min_valid_params) { attributes_for(:review          ).except(:author_id) }
        let(  :invalid_params) { attributes_for(:post, :with_body).except(:author_id) }

        context "with max valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: max_valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { post: max_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(max_valid_params).and_be_valid
          end

          it "post belongs to current_user" do
            post :create, params: { post: max_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(author: controller.current_user)
          end

          it "redirects to post" do
            post :create, params: { post: max_valid_params }

            is_expected.to send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with min valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: min_valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(min_valid_params).and_be_valid
          end

          it "post belongs to current_user" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(author: controller.current_user)
          end

          it "redirects to post" do
            post :create, params: { post: min_valid_params }

            is_expected.to send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            is_expected.to successfully_render("admin/posts/new")

            is_expected.to define_all_tabs.and_select("post-choose-work")

            expect(assigns(:post)).to be_a_populated_new_post
            expect(assigns(:post)).to have_coerced_attributes(invalid_params)
            expect(assigns(:post)).to be_invalid
          end
        end
      end

      context "new work" do
        let(:max_valid_params) { attributes_for(:complete_review_with_new_work).except(:author_id).deep_stringify_keys }
        let(:min_valid_params) { attributes_for(         :review_with_new_work).except(:author_id).deep_stringify_keys }
        let(  :invalid_params) { attributes_for( :invalid_review_with_new_work).except(:author_id).deep_stringify_keys }

        context "with max valid params" do
          it "creates a new Post" do
            post :create, params: { post: max_valid_params }

            expect {
              post :create, params: { post: max_valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates a new Work" do
            expect {
              post :create, params: { post: max_valid_params }
            }.to change(Work, :count).by(1)
          end

          it "creates new Credits" do
            expect {
              post :create, params: { post: max_valid_params }
            }.to change(Credit, :count).by(3)
          end

          it "creates the right attributes" do
            post :create, params: { post: max_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(max_valid_params).and_be_valid
          end

          it "post belongs to current_user" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(author: controller.current_user)
          end

          it "redirects to post" do
            post :create, params: { post: min_valid_params }

            is_expected.to send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with min valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: min_valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates a new Work" do
            expect {
              post :create, params: { post: min_valid_params }
            }.to change(Work, :count).by(1)
          end

          it "creates new Credits" do
            expect {
              post :create, params: { post: min_valid_params }
            }.to change(Credit, :count).by(1)
          end

          it "creates the right attributes" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(min_valid_params).and_be_valid
          end

          it "post belongs to current_user" do
            post :create, params: { post: min_valid_params }

            is_expected.to assign(Post.last, :post).with_attributes(author: controller.current_user)
          end

          it "redirects to post" do
            post :create, params: { post: min_valid_params }

            is_expected.to send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            is_expected.to successfully_render("admin/posts/new")

            is_expected.to define_all_tabs.and_select("post-new-work")

            expect(assigns(:post)).to be_a_populated_new_post
            expect(assigns(:post)).to have_coerced_attributes(invalid_params)
            expect(assigns(:post)).to be_invalid
          end
        end
      end
    end

    describe "GET #edit" do
      context "standalone" do
        let(:post) { create(:minimal_post) }

        it "renders" do
          get :edit, params: { id: post.to_param }

          is_expected.to successfully_render("admin/posts/edit")
          is_expected.to assign(post, :post)

          is_expected.to define_only_the_standalone_tab
        end
      end

      context "review" do
        let(:post) { create(:review) }

        it "renders" do
          get :edit, params: { id: post.to_param }

          is_expected.to successfully_render("admin/posts/edit")
          is_expected.to assign(post, :post)

          is_expected.to define_only_the_review_tabs.and_select("post-choose-work")
        end
      end
    end

    describe "PUT #update" do
      context "draft" do
        context "standalone" do
          let(:post) { create(:standalone_post) }

          let(:min_valid_params) { { "title" => "New Title" } }
          let(  :invalid_params) { { "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { id: post.to_param, post: min_valid_params }
            end

            it "updates the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.update"
            ) }
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit")
              is_expected.to assign(post, :post)

              is_expected.to assign(post, :post).with_attributes(invalid_params).and_be_invalid

              is_expected.to define_only_the_standalone_tab
            end
          end
        end

        context "review" do
          let(:post) { create(:review) }

          let(:min_valid_params) { { "work_id" => create(:minimal_work).id } }
          let(  :invalid_params) { { "work_id" => ""                       } }

          context "with valid params" do
            before(:each) do
              put :update, params: { id: post.to_param, post: min_valid_params }
            end

            it "updates the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.update"
            ) }
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit")

              is_expected.to assign(post, :post).with_attributes(invalid_params).and_be_invalid

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")
            end
          end
        end

        describe "replacing work with new work" do
          let!(:post) { create(:review) }

          let(:min_valid_params) { attributes_for(        :review_with_new_work).except(:author_id).merge(work_id: post.work_id).deep_stringify_keys }
          let(  :invalid_params) { attributes_for(:invalid_review_with_new_work).except(:author_id).merge(work_id: post.work_id).deep_stringify_keys }

          context "with valid params" do
            it "updates the requested post, ignoring work_id in favor of work_attributes" do
              expect {
                put :update, params: { id: post.to_param, post: min_valid_params }
              }.to change { Work.count }.by(1)

              is_expected.to assign(post, :post).with_attributes(min_valid_params.except("work_id")).and_be_valid
            end

            specify do
              put :update, params: { id: post.to_param, post: min_valid_params }

              is_expected.to send_user_to(admin_post_path(post)).with_flash(
                :success, "admin.flash.posts.success.update"
              )
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit")

              is_expected.to assign(post, :post).with_attributes(invalid_params.except("work_id")).and_be_invalid

              expect(assigns(:post).work).to be_a_new(Work)
              expect(assigns(:post).work).to be_invalid

              is_expected.to define_only_the_review_tabs.and_select("post-new-work")
            end
          end
        end
      end

      context "replacing slug" do
        let(:post) { create(:standalone_post) }

        context "with custom slug" do
          let(:min_valid_params) { { "slug" => "custom/slug" } }

          before(:each) do
            put :update, params: { id: post.to_param, post: min_valid_params }
          end

          it "sets custom slug" do
            is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

            expect(assigns(:post).dirty_slug?).to eq(true)
          end

          it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end

        context "with blank slug" do
          let(:min_valid_params) { { "slug" => "" } }

          before(:each) do
            put :update, params: { id: post.to_param, post: min_valid_params }
          end

          it "regenerates slug" do
            is_expected.to assign(post, :post).and_be_valid

            expect(assigns(:post).slug).to_not be_blank
            expect(assigns(:post).dirty_slug?).to eq(false)
          end

          it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end
      end

      context "publishing" do
        context "standalone" do
          let(:post) { create(:standalone_post, :draft) }

          let(:min_valid_params) { { "body" => "New body.", "title" => "New title." } }
          let(  :invalid_params) { { "body" => ""         , "title" => ""           } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "publish", id: post.to_param, post: min_valid_params }
            end

            it "updates and publishes the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_published
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.publish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates post and renders edit with message" do
              put :update, params: { step: "publish", id: post.to_param, post: min_valid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(post.reload).to_not be_published
            end
          end

          context "with invalid params" do
            it "fails to publish and renders edit with message and errors" do
              put :update, params: { step: "publish", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                body:  :blank_during_publish,
                title: :blank
              })

              expect(post.reload).to_not be_published
            end
          end
        end

        context "review" do
          let(:post) { create(:review, :draft) }

          let(:min_valid_params) { { "body" => "New body.", "work_id" => create(:minimal_work).id } }
          let(  :invalid_params) { { "body" => ""         , "work_id" => ""               } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "publish", id: post.to_param, post: min_valid_params }
            end

            it "updates and publishes the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_published
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.publish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates post and renders edit with message" do
              put :update, params: { step: "publish", id: post.to_param, post: min_valid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")

              is_expected.to assign(post, :post).with_attributes({
                body:            min_valid_params["body"   ],
                current_work_id: min_valid_params["work_id"]
              })

              expect(post.reload).to_not be_published
            end
          end

          context "with invalid params" do
            it "fails to publish and renders edit with message and errors" do
              put :update, params: { step: "publish", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                body:    :blank_during_publish,
                work_id: :blank
              })

              expect(post.reload).to_not be_published
            end
          end
        end
      end

      context "unpublishing" do
        context "standalone" do
          let(:post) { create(:standalone_post, :published) }

          let(:min_valid_params) { { "body" => "", "title" => "New title."} }
          let(  :invalid_params) { { "body" => "", "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unpublish", id: post.to_param, post: min_valid_params }
            end

            it "unpublishes and updates the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_draft
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.unpublish"
            ) }
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(:error, nil)

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                title: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end

        context "review" do
          let(:post) { create(:review, :published) }

          let(:min_valid_params) { { "body" => "", "work_id" => create(:minimal_work).id } }
          let(  :invalid_params) { { "body" => "", "work_id" => ""                       } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unpublish", id: post.to_param, post: min_valid_params }
            end

            it "unpublishes and updates the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_draft
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.unpublish"
            ) }
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(:error, nil)

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                work_id: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end
      end

      context "scheduling" do
        context "standalone" do
          let(:post) { create(:standalone_post, :draft) }

          let(:min_valid_params) { { "body" => "New body.", "title" => "New title.", publish_on: "01/01/2050" } }
          let(  :invalid_params) { { "body" => "",          "title" => ""                                     } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "schedule", id: post.to_param, post: min_valid_params }
            end

            it "updates and schedules the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_scheduled
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.schedule"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates post and renders edit with message" do
              put :update, params: { step: "schedule", id: post.to_param, post: min_valid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(post.reload).to_not be_scheduled
            end
          end

          context "with invalid params" do
            it "fails to schedule and renders edit with message and errors" do
              put :update, params: { step: "schedule", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                body:  :blank_during_publish,
                title: :blank
              })

              expect(post.reload).to_not be_scheduled
            end
          end
        end

        context "review" do
          let(:post) { create(:review) }

          let(:min_valid_params) { { "body" => "New body.", "work_id" => create(:minimal_work).id, publish_on: "01/01/2050" } }
          let(  :invalid_params) { { "body" => ""         , "work_id" => ""                                                 } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "schedule", id: post.to_param, post: min_valid_params }
            end

            it "updates and schedules the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_scheduled
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.schedule"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)
            end

            it "updates post and renders edit with message" do
              put :update, params: { step: "schedule", id: post.to_param, post: min_valid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")

              is_expected.to assign(post, :post).with_attributes({
                body:            min_valid_params["body"   ],
                current_work_id: min_valid_params["work_id"]
              })

              expect(post.reload).to_not be_scheduled
            end
          end

          context "with invalid params" do
            it "fails to schedule and renders edit with message and errors" do
              put :update, params: { step: "schedule", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.schedule"
              )

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                body:    :blank_during_publish,
                work_id: :blank
              })

              expect(post.reload).to_not be_scheduled
            end
          end
        end
      end

      context "unscheduling" do
        context "standalone" do
          let(:post) { create(:standalone_post, :scheduled) }

          let(:min_valid_params) { { "body" => "", "title" => "New title."} }
          let(  :invalid_params) { { "body" => "", "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unschedule", id: post.to_param, post: min_valid_params }
            end

            it "unschedules and updates the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_draft
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.unschedule"
            ) }
          end

          context "with invalid params" do
            it "unschedules and renders edit with errors" do
              put :update, params: { step: "unschedule", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(:error, nil)

              is_expected.to define_only_the_standalone_tab

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                title: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end

        context "review" do
          let(:post) { create(:review, :scheduled) }

          let(:min_valid_params) { { "body" => "", "work_id" => create(:minimal_work).id } }
          let(  :invalid_params) { { "body" => "", "work_id" => ""                       } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unschedule", id: post.to_param, post: min_valid_params }
            end

            it "unschedules and updates the requested post" do
              is_expected.to assign(post, :post).with_attributes(min_valid_params).and_be_valid

              expect(assigns(:post)).to be_draft
            end

            it { is_expected.to send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.unschedule"
            ) }
          end

          context "with invalid params" do
            it "unschedules and renders edit with errors" do
              put :update, params: { step: "unschedule", id: post.to_param, post: invalid_params }

              is_expected.to successfully_render("admin/posts/edit").with_flash(:error, nil)

              is_expected.to define_only_the_review_tabs.and_select("post-choose-work")

              is_expected.to assign(post, :post).with_attributes(invalid_params).with_errors({
                work_id: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:post) { create(:minimal_post) }

      it "destroys the requested post" do
        expect {
          delete :destroy, params: { id: post.to_param }
        }.to change(Post, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: post.to_param }

        is_expected.to send_user_to(admin_posts_path).with_flash(
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
          "Post",
          "All",
        ])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "Title",
          "Author",
          "Type",
          "Status",
        ])
      end
    end
  end
end
