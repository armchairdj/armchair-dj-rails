# frozen_string_literal: true

class Admin::PostsController < AdminController
  before_action :find_collection, only: [
    :index
  ]

  before_action :build_new_instance, only: [
    :new,
    :create
  ]

  before_action :find_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :sanitize_create_params, only: [
    :create,
  ]

  before_action :sanitize_update_params, only: [
    :update
  ]

  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
  ]

  before_action :authorize_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :prepare_form, only: [
    :new,
    :edit
  ]

  # GET /posts
  # GET /posts.json
  def index

  end

  # GET /posts/1
  # GET /posts/1.json
  def show

  end

  # GET /posts/new
  def new

  end

  # POST /posts
  # POST /posts.json
  def create
    @post.attributes = @sanitized_params

    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_post_path(@post), success: I18n.t("admin.flash.posts.success.create") }
        format.json { render :show, status: :created, location: @post }
      else
        prepare_form

        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /posts/1/edit
  def edit

  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    case params[:step]
    when "publish"
      respond_to_update :update_and_publish,    "admin.flash.posts.success.publish",    :published?, "admin.flash.posts.error.publish"
    when "unpublish"
      respond_to_update :update_and_unpublish,  "admin.flash.posts.success.unpublish",  :draft?,     "admin.flash.posts.error.unpublish"
    when "schedule"
      respond_to_update :update_and_schedule,   "admin.flash.posts.success.schedule",   :scheduled?, "admin.flash.posts.error.schedule"
    when "unschedule"
      respond_to_update :update_and_unschedule, "admin.flash.posts.success.unschedule", :draft?,     "admin.flash.posts.error.unschedule"
    else
      respond_to_update :update,                "admin.flash.posts.success.update"
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to admin_posts_path, success: I18n.t("admin.flash.posts.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @posts = scoped_and_sorted_collection
  end

  def build_new_instance
    @post = Post.new
  end

  def find_instance
    @post = Post.find(params[:id])
  end

  def sanitize_create_params
    fetched = instance_params

    fetched.delete(:slug)
    fetched.delete(:publish_on)

    if fetched[:work_attributes].present? && fetched[:work_attributes][:title].present?
      fetched.delete(:title)
      fetched.delete(:work_id)
    elsif fetched [:work_id].present?
      fetched.delete(:title)
      fetched.delete(:work_attributes)
    else
      fetched.delete(:work_id)
      fetched.delete(:work_attributes)
    end

    @sanitized_params = fetched.merge(author: current_user)
  end

  def sanitize_update_params
    fetched = instance_params

    if @post.standalone?
      fetched.delete(:work_attributes)
      fetched.delete(:work_id)
    elsif @post.review?
      fetched.delete(:title)
    end

    @sanitized_params = fetched
  end

  def instance_params
    params.fetch(:post, {}).permit(
      :title,
      :body,
      :summary,
      :slug,
      :publish_on,
      :work_id,
      :tag_ids => [],
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ],
      :work_attributes => [
        :id,
        :post_id,
        :medium_id,
        :title,
        :subtitle,
        :credits_attributes => [
          :id,
          :work_id,
          :_destroy,
          :creator_id
        ]
      ]
    )
  end

  def prepare_form
    @available_tabs = which_tabs
    @selected_tab   = which_tab

    @post.prepare_links

    return if @post.persisted? && @post.standalone?

    @post.prepare_work_for_editing(@sanitized_params)

    @creators = Creator.all.alpha
    @media    = Medium.all.alpha
    @tags     = Tag.for_posts
    @works    = Work.grouped_options
  end

  def authorize_instance
    authorize @post
  end

  def which_tabs
    case action_name
    when "new", "create"
      ["post-choose-work", "post-new-work", "post-standalone"]
    when "edit", "update"
      if @post.standalone?
        ["post-standalone"]
      else
        ["post-choose-work", "post-new-work"]
      end
    end
  end

  def which_tab
    case action_name
    when "new"
      "post-choose-work"
    when "create"
      if @sanitized_params[:work_attributes].present?
        "post-new-work"
      elsif @sanitized_params[:title].present?
        "post-standalone"
      else
        "post-choose-work"
      end
    when "edit"
      if @post.standalone?
        "post-standalone"
      else
        "post-choose-work"
      end
    when "update"
      if @post.standalone?
        "post-standalone"
      elsif @sanitized_params[:work_attributes].present?
        "post-new-work"
      else
        "post-choose-work"
      end
    end
  end

  def respond_to_update(update_method, success, success_method = nil, failure = nil)
    respond_to do |format|
      if @post.send(update_method, @sanitized_params)
        format.html { redirect_to admin_post_path(@post), success: I18n.t(success) }
        format.json { render :show, status: :ok, location: @post }
      else
        prepare_form

        if success_method
          if @post.send(success_method)
            flash.now[:success] = I18n.t(success)
          else
            flash.now[:error  ] = I18n.t(failure)
          end
        end

        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def allowed_scopes
    super.reverse_merge({
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published,
      "Review"     => :review,
      "Post"       => :standalone,
    })
  end

  def allowed_sorts
    always  = "posts.alpha ASC"

    super(always).merge({
      "Title"   => "#{always}",
      "Type"    => "media.name ASC, #{always}",
      "Status"  => "posts.published_at DESC, posts.publish_on DESC, posts.updated_at DESC, #{always}",
    })
  end
end
