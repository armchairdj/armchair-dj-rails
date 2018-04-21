require "rails_helper"

RSpec.describe Admin::PostsController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  context "as admin" do
    login_admin

    describe "GET #index" do
      context "without records" do
        context ":draft scope (default)" do
          it "renders" do
            get :index

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(0)
            expect(assigns(:posts).size       ).to eq(0)
          end
        end

        context ":published scope" do
          it "renders" do
            get :index, params: { scope: "published" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(0)
            expect(assigns(:posts).size       ).to eq(0)
          end
        end

        context ":all scope" do
          it "renders" do
            get :index, params: { scope: "all" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(0)
            expect(assigns(:posts).size       ).to eq(0)
          end
        end
      end

      context "with records" do
        context ":draft scope (default)" do
          before(:each) do
            ( per_page / 2     ).times { create(:song_review,     :draft) }
            ((per_page / 2) + 1).times { create(:standalone_post, :draft) }
          end

          it "renders" do
            get :index

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(per_page + 1)
            expect(assigns(:posts).size       ).to eq(per_page)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(per_page + 1)
            expect(assigns(:posts).size       ).to eq(1)
          end
        end

        context ":published scope" do
          before(:each) do
            ( per_page / 2     ).times { create(:song_review,     :published) }
            ((per_page / 2) + 1).times { create(:standalone_post, :published) }
          end

          it "renders" do
            get :index, params: { scope: "published" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(per_page + 1)
            expect(assigns(:posts).size       ).to eq(per_page)
          end

          it "renders second page" do
            get :index, params: { scope: "published", page: "2" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(per_page + 1)
            expect(assigns(:posts).size       ).to eq(1)
          end
        end

        context ":all scope" do
          before(:each) do
            ((per_page / 4)    ).times { create(:song_review,     :draft    ) }
            ((per_page / 4)    ).times { create(:standalone_post, :draft    ) }
            ((per_page / 4)    ).times { create(:song_review,     :published) }
            ((per_page / 4) + 1).times { create(:standalone_post, :published) }
          end

          it "renders" do
            get :index, params: { scope: "all" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(per_page + 1)
            expect(assigns(:posts).size       ).to eq(per_page)
          end

          it "renders second page" do
            get :index, params: { scope: "all", page: "2" }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/index")

            expect(assigns(:posts).total_count).to eq(per_page + 1)
            expect(assigns(:posts).size       ).to eq(1)
          end
        end
      end
    end

    describe "GET #show" do
      context "standalone" do
        let(:post) { create(:standalone_post) }

        it "renders" do
          get :show, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/show")

          expect(assigns(:post)).to eq(post)
        end
      end

      context "review" do
        let(:post) { create(:song_review) }

        it "renders" do
          get :show, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/show")

          expect(assigns(:post)).to eq(post)
        end
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        expect(response).to be_success
        expect(response).to render_template("admin/posts/new")

        expect(assigns(:post)                          ).to be_a_new(Post)
        expect(assigns(:post).work                     ).to be_a_new(Work)
        expect(assigns(:post).work.contributions.length).to eq(10)

        expect(assigns).to define_all_tabs
        expect(assigns(:selected_tab)).to eq("post-choose-work")
      end
    end

    describe "POST #create" do
      context "standalone" do
        let(  :valid_params) { { "title" => "title", "body" => "body" } }
        let(:invalid_params) { valid_params.except("title") }

        pending "incomplete"

        context "with valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it "redirects to post" do
            post :create, params: { post: valid_params }

            expect(response).to redirect_to(admin_post_path(assigns[:post]))
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/new")

            expect(assigns(:post)       ).to be_a_new(Post)
            expect(assigns(:post).valid?).to eq(false)

            expect(assigns).to define_all_tabs
            expect(assigns(:selected_tab)).to eq("post-choose-work")
          end
        end
      end

      context "existing work" do
        let(  :valid_params) { { "body" => "body", "work_id" => create(:song).id } }
        let(:invalid_params) { valid_params.except("work_id") }

        pending "incomplete"

        context "with valid params" do
          it "creates a new Post" do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it "redirects to post" do
            post :create, params: { post: valid_params }

            expect(response).to redirect_to(admin_post_path(assigns[:post]))
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/new")

            expect(assigns(:post)       ).to be_a_new(Post)
            expect(assigns(:post).valid?).to eq(false)

            expect(assigns).to define_all_tabs
            expect(assigns(:selected_tab)).to eq("post-choose-work")
          end
        end
      end

      context "new work" do
        let(:valid_params) { {
          "body"            => "body",
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

        let(:invalid_params) { valid_params.except("work_attributes") }

        pending "incomplete"

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

            expect(response).to redirect_to(admin_post_path(assigns[:post]))
          end
        end

        context "with invalid params" do
          it "renders new" do
            post :create, params: { post: invalid_params }

            expect(response).to be_success
            expect(response).to render_template("admin/posts/new")

            expect(assigns(:post)       ).to be_a_new(Post)
            expect(assigns(:post).valid?).to eq(false)

            expect(assigns).to define_all_tabs
            expect(assigns(:selected_tab)).to eq("post-choose-work")
          end
        end
      end
    end

    describe "GET #edit" do
      context "standalone" do
        let(:post) { create(:minimal_post) }

        it "renders" do
          get :edit, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/edit")

          expect(assigns(:post)).to eq(post)

          expect(assigns).to define_only_the_standalone_tab
        end
      end

      context "review" do
        let(:post) { create(:song_review) }

        it "renders" do
          get :edit, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/edit")

          expect(assigns(:post)).to eq(post)

          expect(assigns).to define_only_the_review_tabs
          expect(assigns(:selected_tab)).to eq("post-choose-work")
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
            it "updates the requested post" do
              put :update, params: { id: post.to_param, post: valid_params }

              expect(assigns(:post)      ).to eq(post)
              expect(assigns(:post).title).to eq(valid_params["title"])
            end

            it "redirects to post" do
              put :update, params: { id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)       ).to eq(post)
              expect(assigns(:post).valid?).to eq(false)

              expect(assigns).to define_only_the_standalone_tab
            end
          end
        end

        context "review" do
          let(:post) { create(:song_review) }

          let(  :valid_params) { { "work_id" => create(:song).id } }
          let(:invalid_params) { { "work_id" => ""               } }

          context "with valid params" do
            it "updates the requested post" do
              put :update, params: { id: post.to_param, post: valid_params }

              expect(assigns(:post)        ).to eq(post)
              expect(assigns(:post).work_id).to eq(valid_params["work_id"])
            end

            it "redirects to post" do
              put :update, params: { id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)       ).to eq(post)
              expect(assigns(:post).valid?).to eq(false)

              expect(assigns).to define_only_the_review_tabs
              expect(assigns(:selected_tab)).to eq("post-choose-work")
            end
          end
        end
      end

      context "publish" do
        context "standalone" do
          let(:post) { create(:standalone_post) }

          let(  :valid_params) { { "body" => "New body.", "title" => "New title." } }
          let(:invalid_params) { { "body" => ""         , "title" => ""           } }

          context "slug" do
            pending "with custom slug"
            pending "with blank slug"
          end

          context "with valid params" do
            it "updates and publishes the requested post" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).title       ).to eq(valid_params["title"])
              expect(assigns(:post).body        ).to eq(valid_params["body" ])
              expect(assigns(:post).published?  ).to eq(true)
              expect(assigns(:post).published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            end

            it "redirects to post" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))

              expect(flash[:notice]).to eq(I18n.t("admin.flash.posts.notice.publish"))
            end
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_publish?).and_return(false)
            end

            it "updates post and renders edit with message" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).title       ).to eq(valid_params["title"])
              expect(assigns(:post).body        ).to eq(valid_params["body" ])
              expect(assigns(:post).valid?      ).to eq(true)

              expect(assigns).to define_only_the_standalone_tab

              post.reload

              expect(post.published?  ).to eq(false)
              expect(post.published_at).to eq(nil)

              expect(flash[:error]).to eq(I18n.t("admin.flash.posts.error.publish"))
            end
          end

          context "with invalid params" do
            it "fails to publish and renders edit with message and errors" do
              put :update, params: { step: "publish", id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).title       ).to eq(nil)
              expect(assigns(:post).body        ).to eq(nil)
              expect(assigns(:post).published_at).to eq(nil)
              expect(assigns(:post).published?  ).to eq(false)

              expect(assigns(:post).errors.details[:body ].first).to eq({ error: :blank_during_publish })
              expect(assigns(:post).errors.details[:title].first).to eq({ error: :blank })

              expect(assigns).to define_only_the_standalone_tab

              expect(flash[:error]).to eq(I18n.t("admin.flash.posts.error.publish"))
            end
          end
        end

        context "review" do
          let(:post) { create(:song_review) }

          let(  :valid_params) { { "body" => "New body.", "work_id" => create(:song).id } }
          let(:invalid_params) { { "body" => ""         , "work_id" => ""               } }

          context "slug" do
            pending "with custom slug"
            pending "with blank slug"
          end

          context "with valid params" do
            it "updates and publishes the requested post" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).body        ).to eq(valid_params["body"   ])
              expect(assigns(:post).work_id     ).to eq(valid_params["work_id"])
              expect(assigns(:post).published?  ).to eq(true)
              expect(assigns(:post).published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            end

            it "redirects to post" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))

              expect(flash[:notice]).to eq(I18n.t("admin.flash.posts.notice.publish"))
            end
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_publish?).and_return(false)
            end

            it "renders edit with message" do
              put :update, params: { step: "publish", id: post.to_param, post: valid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)        ).to eq(post)
              expect(assigns(:post).body   ).to eq(valid_params["body"   ])
              expect(assigns(:post).work_id).to eq(valid_params["work_id"])
              expect(assigns(:post).valid? ).to eq(true)

              post.reload

              expect(post.published?  ).to eq(false)
              expect(post.published_at).to eq(nil)

              expect(flash[:error]).to eq(I18n.t("admin.flash.posts.error.publish"))

              expect(assigns).to define_only_the_review_tabs
              expect(assigns(:selected_tab)).to eq("post-choose-work")
            end
          end

          context "with invalid params" do
            it "renders edit" do
              put :update, params: { step: "publish", id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")


              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).work_id     ).to eq(nil)
              expect(assigns(:post).body        ).to eq(nil)
              expect(assigns(:post).published_at).to eq(nil)
              expect(assigns(:post).published?  ).to eq(false)

              expect(assigns(:post).errors.details[:body   ].first).to eq({ error: :blank_during_publish })
              expect(assigns(:post).errors.details[:work_id].first).to eq({ error: :blank })

              expect(flash[:error]).to eq(I18n.t("admin.flash.posts.error.publish"))

              expect(assigns).to define_only_the_review_tabs
              expect(assigns(:selected_tab)).to eq("post-choose-work")
            end
          end
        end
      end

      context "unpublish" do
        context "standalone" do
          let(:post) { create(:standalone_post, :published) }

          let(  :valid_params) { { "body" => "", "title" => "New title."} }
          let(:invalid_params) { { "body" => "", "title" => ""          } }

          context "slug" do
            pending "with custom slug"
            pending "with blank slug"
          end

          context "with valid params" do
            it "unpublishes and updates the requested post" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).title       ).to eq(valid_params["title"])
              expect(assigns(:post).body        ).to eq(nil)
              expect(assigns(:post).published?  ).to eq(false)
              expect(assigns(:post).published_at).to eq(nil)
            end

            it "redirects to post" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))

              expect(flash[:notice]).to eq(I18n.t("admin.flash.posts.notice.unpublish"))
            end
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_unpublish?).and_return(false)
            end

            it "renders edit with message" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)      ).to eq(post)
              expect(assigns(:post).title).to eq(valid_params["title"])
              expect(assigns(:post).body ).to eq(nil)

              post.reload

              expect(post.published?  ).to eq(true)
              expect(post.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)

              expect(flash[:error]).to eq(I18n.t("admin.flash.posts.error.unpublish"))

              expect(assigns).to define_only_the_standalone_tab
            end
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).title       ).to eq(nil)
              expect(assigns(:post).body        ).to eq(nil)
              expect(assigns(:post).published?  ).to eq(false)
              expect(assigns(:post).published_at).to eq(nil)

              expect(assigns(:post).errors.details[:title].first).to eq({ error: :blank })

              expect(flash[:error]).to eq(nil)

              expect(assigns).to define_only_the_standalone_tab
            end
          end
        end

        context "review" do
          let(:post) { create(:song_review, :published) }

          let(  :valid_params) { { "body" => "", "work_id" => create(:song).id } }
          let(:invalid_params) { { "body" => "", "work_id" => ""               } }

          context "slug" do
            pending "with custom slug"
            pending "with blank slug"
          end

          context "with valid params" do
            it "unpublishes and updates the requested post" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).work_id     ).to eq(valid_params["work_id"])
              expect(assigns(:post).body        ).to eq(nil)
              expect(assigns(:post).published?  ).to eq(false)
              expect(assigns(:post).published_at).to eq(nil)
            end

            it "redirects to post" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))

              expect(flash[:notice]).to eq(I18n.t("admin.flash.posts.notice.unpublish"))
            end
          end

          context "with failed transition" do
            before(:each) do
              allow_any_instance_of(Post).to receive(:can_unpublish?).and_return(false)
            end

            it "renders edit with message" do
              put :update, params: { step: "unpublish", id: post.to_param, post: valid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)        ).to eq(post)
              expect(assigns(:post).work_id).to eq(valid_params["work_id"])
              expect(assigns(:post).body   ).to eq(nil)

              post.reload

              expect(post.published?  ).to eq(true)
              expect(post.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)

              expect(flash[:error]).to eq(I18n.t("admin.flash.posts.error.unpublish"))

              expect(assigns).to define_only_the_review_tabs
              expect(assigns(:selected_tab)).to eq("post-choose-work")
            end
          end

          context "with invalid params" do
            it "unpublishes and renders edit with errors" do
              put :update, params: { step: "unpublish", id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template("admin/posts/edit")

              expect(assigns(:post)             ).to eq(post)
              expect(assigns(:post).work_id     ).to eq(nil)
              expect(assigns(:post).body        ).to eq(nil)
              expect(assigns(:post).published?  ).to eq(false)
              expect(assigns(:post).published_at).to eq(nil)

              expect(assigns(:post).errors.details[:work_id].first).to eq({ error: :blank })

              expect(flash[:error]).to eq(nil)

              expect(assigns).to define_only_the_review_tabs
              expect(assigns(:selected_tab)).to eq("post-choose-work")
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

        expect(response).to redirect_to(admin_posts_path)
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
