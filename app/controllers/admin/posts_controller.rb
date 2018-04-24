class Admin::PostsController < AdminController
  before_action :find_collection, only: [
    :index
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
    @post = Post.new

    prepare_form
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(@sanitized_params)

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
    prepare_form
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    return   publish_and_respond if params[:step] ==   "publish"
    return unpublish_and_respond if params[:step] == "unpublish"

    respond_to do |format|
      if @post.update(@sanitized_params)
        format.html { redirect_to admin_post_path(@post), success: I18n.t("admin.flash.posts.success.update") }
        format.json { render :show, status: :ok, location: @post }
      else
        prepare_form

        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
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

  def find_instance
    @post = Post.find(params[:id])
  end

  def sanitize_create_params
    fetched = instance_params

    fetched.delete(:published_at)

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

    @sanitized_params = fetched
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
      :body,
      :title,
      :slug,
      :work_id,
      :published_at,
      :work_attributes => [
        :post_id,
        :id,
        :_destroy,
        :medium,
        :title,
        :contributions_attributes => [
          :work_id,
          :id,
          :_destroy,
          :role,
          :creator_id
        ]
      ]
    )
  end

  def prepare_form
    @available_tabs = which_tabs
    @selected_tab   = which_tab

    return if @post.persisted? && @post.standalone?

    @post.prepare_work_for_editing(@sanitized_params)

    @creators = policy_scope(Creator).alphabetical
    @roles    = Contribution.grouped_role_options
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

  def publish_and_respond
    respond_to do |format|
      if @post.update_and_publish(@sanitized_params)
        format.html { redirect_to admin_post_path(@post), success: I18n.t("admin.flash.posts.success.publish") }
        format.json { render :show, status: :ok, location: @post }
      else
        prepare_form

        if @post.published?
          flash.now[:success] = I18n.t("admin.flash.posts.success.publish")
        else
          flash.now[:error]  = I18n.t("admin.flash.posts.error.publish")
        end

        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def unpublish_and_respond
    respond_to do |format|
      if @post.update_and_unpublish(@sanitized_params)
        format.html { redirect_to admin_post_path(@post), success: I18n.t("admin.flash.posts.success.unpublish") }
        format.json { render :show, status: :ok, location: @post }
      else
        prepare_form

        if @post.draft?
          flash.now[:success] = I18n.t("admin.flash.posts.success.unpublish")
        else
          flash.now[:error]  = I18n.t("admin.flash.posts.error.unpublish")
        end

        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
end
