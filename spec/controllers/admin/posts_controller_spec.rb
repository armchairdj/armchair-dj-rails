require "rails_helper"

RSpec.describe Admin::PostsController, type: :controller do
  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":draft scope (default)" do
          it "renders" do
            get :index

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(0).of_total_records(0)
          end
        end

        context ":published scope" do
          it "renders" do
            get :index, params: { scope: "published" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(0).of_total_records(0)
          end
        end

        context ":all scope" do
          it "renders" do
            get :index, params: { scope: "all" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(0).of_total_records(0)
          end
        end
      end

      context "with records" do
        context ":draft scope (default)" do
          before(:each) do
            10.times { create(:song_review,     :draft) }
            11.times { create(:standalone_post, :draft) }
          end

          it "renders" do
            get :index

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(1).of_total_records(21)
          end
        end

        context ":published scope" do
          before(:each) do
            10.times { create(:song_review,     :published) }
            11.times { create(:standalone_post, :published) }
          end

          it "renders" do
            get :index, params: { scope: "published" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "published", page: "2" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(1).of_total_records(21)
          end
        end

        context ":all scope" do
          before(:each) do
            5.times { create(:song_review,     :draft    ) }
            5.times { create(:standalone_post, :draft    ) }
            5.times { create(:song_review,     :published) }
            6.times { create(:standalone_post, :published) }
          end

          it "renders" do
            get :index, params: { scope: "all" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { scope: "all", page: "2" }

            should successfully_render("admin/posts/index")
            expect(assigns(:posts)).to paginate(1).of_total_records(21)
          end
        end
      end
    end

    describe "GET #show" do
      context "standalone" do
        let(:post) { create(:standalone_post) }

        it "renders" do
          get :show, params: { id: post.to_param }

          should successfully_render("admin/posts/show").assigning(post, :post)
        end
      end

      context "review" do
        let(:post) { create(:song_review) }

        it "renders" do
          get :show, params: { id: post.to_param }

          should successfully_render("admin/posts/show").assigning(post, :post)
        end
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        should successfully_render("admin/posts/new")

        should define_all_tabs.and_select("post-choose-work")

        expect(assigns(:post)).to be_a_populated_new_post
      end
    end

    describe "POST #create" do
      context "standalone" do
        let(  :valid_params) { { "title" => "title" } }
        let(:invalid_params) { { "body" => "only the body" } }

        context "with valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it "redirects to post" do
            post :create, params: { post: valid_params }

            should send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            should successfully_render("admin/posts/new")

            should define_all_tabs.and_select("post-choose-work")

            expect(assigns(:post)).to be_a_populated_new_post
          end
        end
      end

      context "existing work" do
        let(  :valid_params) { { "work_id" => create(:song).id } }
        let(:invalid_params) { { "body" => "only the body" } }

        context "with valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it "redirects to post" do
            post :create, params: { post: valid_params }

            should send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            should successfully_render("admin/posts/new")

            should define_all_tabs.and_select("post-choose-work")

            expect(assigns(:post)).to be_a_populated_new_post
          end
        end
      end

      context "new work" do
        let(:valid_params) { {
          "work_attributes" => {
            "medium"                   => "song",
            "title"                    => "Hounds of Love",
            "contributions_attributes" => {
              "0" => {
                "role"       => "creator",
                "creator_id" => create(:musician).id
              }
            }
          }
        } }

        let(:invalid_params) { {
          "work_attributes" => {
            "medium"                   => "",
            "title"                    => "Hounds of Love",
            "contributions_attributes" => {
              "0" => {
                "role"       => "creator",
                "creator_id" => create(:musician).id
              }
            }
          }
        } }

        context "with valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it "creates a new Work" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Work, :count).by(1)
          end

          it "creates a new Contribution" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Contribution, :count).by(1)
          end

          it "redirects to post" do
            post :create, params: { post: valid_params }

            should send_user_to(
              admin_post_path(assigns(:post))
            ).with_flash(:success, "admin.flash.posts.success.create")
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            should successfully_render("admin/posts/new")

            should define_all_tabs.and_select("post-new-work")

            expect(assigns(:post)).to be_a_populated_new_post
          end
        end
      end
    end

    describe "GET #edit" do
      context "standalone" do
        let(:post) { create(:minimal_post) }

        it "renders" do
          get :edit, params: { id: post.to_param }

          should successfully_render("admin/posts/edit").assigning(post, :post)

          should define_only_the_standalone_tab
        end
      end

      context "review" do
        let(:post) { create(:song_review) }

        it "renders" do
          get :edit, params: { id: post.to_param }

          should successfully_render("admin/posts/edit").assigning(post, :post)

          should define_only_the_review_tabs.and_select("post-choose-work")
        end
      end
    end

    describe "PUT #update" do
      context "draft" do
        context "standalone" do
          let(:post) { create(:standalone_post) }

          let(  :valid_params) { { "title" => "New Title" } }
          let(:invalid_params) { { "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { id: post.to_param, post: valid_params }
            end

            it "updates the requested post" do
              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid
            end

            it { should send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.update"
            ) }
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").assigning(post, :post)

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(invalid_params).and_be_invalid

              should define_only_the_standalone_tab
            end
          end
        end

        context "review" do
          let(:post) { create(:song_review) }

          let(  :valid_params) { { "work_id" => create(:song).id } }
          let(:invalid_params) { { "work_id" => ""               } }

          context "with valid params" do
            before(:each) do
              put :update, params: { id: post.to_param, post: valid_params }
            end

            it "updates the requested post" do
              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid
            end

            it { should send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.update"
            ) }
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").assigning(post, :post)

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(invalid_params).and_be_invalid

              should define_only_the_review_tabs.and_select("post-choose-work")
            end
          end
        end

        describe "replacing work_id with work_attributes" do
          let!(:post) { create(:product_review) }

          let(:kate_bush) { create(:musician, name: "Kate Bush") }

          let(:valid_params) { {
            "work_id"         => post.work.id,
            "work_attributes" => {
              "medium"                   => "song",
              "title"                    => "Hounds of Love",
              "contributions_attributes" => {
                "0" => {
                  "role"       => "creator",
                  "creator_id" => kate_bush.id
                }
              }
            }
          } }

          let(:invalid_params) { {
            "work_id"         => post.work.id,
            "work_attributes" => {
              "medium"                   => "",
              "title"                    => "Hounds of Love",
              "contributions_attributes" => {
                "0" => {
                  "role"       => "creator",
                  "creator_id" => kate_bush.id
                }
              }
            }
          } }

          context "with valid params" do
            it "updates the requested post, ignoring work_id in favor of work_attributes" do
              expect {
                put :update, params: { id: post.to_param, post: valid_params }
              }.to change { Work.count }.by(1)

              expect(post).to be_assigned_to(assigns(:post)).and_be_valid

              expect(assigns(:post).work).to have_attributes(
                medium: "song",
                title:  "Hounds of Love"
              )

              expect(assigns(:post).work.contributors.first).to eq(kate_bush)
            end

            specify do
              put :update, params: { id: post.to_param, post: valid_params }

              should send_user_to(admin_post_path(post)).with_flash(
                :success, "admin.flash.posts.success.update"
              )
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").assigning(post, :post)

              expect(post).to be_assigned_to(assigns(:post)).and_be_invalid

              expect(assigns(:post).work).to be_a_new(Work)
              expect(assigns(:post).work).to be_invalid

              should define_only_the_review_tabs.and_select("post-new-work")
            end
          end
        end
      end

      context "replacing automatic slug" do
        let(:post) { create(:standalone_post) }

        context "with custom slug" do
          let(:valid_params) { { "slug" => "custom/slug" } }

          before(:each) do
            put :update, params: { id: post.to_param, post: valid_params }
          end

          it "sets custom slug" do
            expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid

            expect(assigns(:post).dirty_slug?).to eq(true)
          end

          it { should send_user_to(admin_post_path(post)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end

        context "with blank slug" do
          let(:valid_params) { { "slug" => "" } }

          before(:each) do
            put :update, params: { id: post.to_param, post: valid_params }
          end

          it "regenerates slug" do
            expect(post).to be_assigned_to(assigns(:post)).and_be_valid

            expect(assigns(:post).slug).to_not be_blank
            expect(assigns(:post).dirty_slug?).to eq(false)
          end

          it { should send_user_to(admin_post_path(post)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end
      end

      context "publishing" do
        context "standalone" do
          let(:post) { create(:standalone_post) }

          let(  :valid_params) { { "body" => "New body.", "title" => "New title." } }
          let(:invalid_params) { { "body" => ""         , "title" => ""           } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }
            end

            it "updates and publishes the requested post" do
              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid

              expect(assigns(:post)).to be_published
            end

            it { should send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.publish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_publish?).and_return(false)
            end

            it "updates post and renders edit with message" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              should successfully_render("admin/posts/edit").assigning(post, :post).with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid

              should define_only_the_standalone_tab

              expect(post.reload).to be_draft
            end
          end

          context "with invalid params" do
            it "fails to publish and renders edit with message and errors" do
              put :update, params: { step: "publish", id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").assigning(post, :post).with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              should define_only_the_standalone_tab

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(invalid_params).and_have_errors({
                body:  :blank_during_publish,
                title: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end

        context "review" do
          let(:post) { create(:song_review) }

          let(  :valid_params) { { "body" => "New body.", "work_id" => create(:song).id } }
          let(:invalid_params) { { "body" => ""         , "work_id" => ""               } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }
            end

            it "updates and publishes the requested post" do
              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid

              expect(assigns(:post)).to be_published
            end

            it { should send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.publish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_publish?).and_return(false)
            end

            it "renders edit with message" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              should successfully_render("admin/posts/edit").assigning(post, :post).with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              should define_only_the_review_tabs.and_select("post-choose-work")

              expect(post).to be_assigned_to(assigns(:post)).with_attributes({
                body:            valid_params["body"   ],
                current_work_id: valid_params["work_id"]
              })

              expect(post.reload).to be_draft
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { step: "publish", id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.publish"
              )

              should define_only_the_review_tabs.and_select("post-choose-work")

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(invalid_params).and_have_errors({
                body:    :blank_during_publish,
                work_id: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end
      end

      context "unpublishing" do
        context "standalone" do
          let(:post) { create(:standalone_post, :published) }

          let(  :valid_params) { { "body" => "", "title" => "New title."} }
          let(:invalid_params) { { "body" => "", "title" => ""          } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }
            end

            it "unpublishes and updates the requested post" do
              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid

              expect(assigns(:post)).to be_draft
            end

            it { should send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.unpublish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_unpublish?).and_return(false)
            end

            it "renders edit with message" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              should successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.unpublish"
              )

              should define_only_the_standalone_tab

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_invalid

              expect(post.reload).to_not be_draft
            end
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").with_flash(:error, nil)

              should define_only_the_standalone_tab

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(invalid_params).and_have_errors({
                title: :blank
              })

              expect(assigns(:post)).to be_draft
            end
          end
        end

        context "review" do
          let(:post) { create(:song_review, :published) }

          let(  :valid_params) { { "body" => "", "work_id" => create(:song).id } }
          let(:invalid_params) { { "body" => "", "work_id" => ""               } }

          context "with valid params" do
            before(:each) do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }
            end

            it "unpublishes and updates the requested post" do
              expect(post).to be_assigned_to(assigns(:post)).with_attributes(valid_params).and_be_valid

              expect(assigns(:post)).to be_draft
            end

            it { should send_user_to(admin_post_path(post)).with_flash(
              :success, "admin.flash.posts.success.unpublish"
            ) }
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_unpublish?).and_return(false)
            end

            it "renders edit with message" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              should successfully_render("admin/posts/edit").with_flash(
                :error, "admin.flash.posts.error.unpublish"
              )

              should define_only_the_review_tabs.and_select("post-choose-work")

              expect(post).to be_assigned_to(assigns(:post)).with_attributes({
                body:            valid_params["body"   ],
                current_work_id: valid_params["work_id"]
              }).and_be_invalid

              expect(post.reload).to be_published
            end
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: post.to_param, post: invalid_params }

              should successfully_render("admin/posts/edit").with_flash(:error, nil)

              should define_only_the_review_tabs.and_select("post-choose-work")

              expect(post).to be_assigned_to(assigns(:post)).with_attributes(invalid_params).and_have_errors({
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

        should send_user_to(admin_posts_path).with_flash(
          :success, "admin.flash.posts.success.destroy"
        )
      end
    end
  end

  context "concerns" do
    it_behaves_like "an admin controller" do
      let(:expected_redirect_for_seo_paginatable) { admin_posts_path }
      let(:instance                             ) { create(:minimal_post) }
    end
  end
end
