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

  before_action :build_new_instance, only: [
    :new
  ]

  before_action :sanitize_params, only: [
    :create,
    :update
  ]

  before_action :build_new_instance_from_params, only: [
    :create
  ]

  before_action :prepare_form, only: [
    :new,
    :edit
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

  end

  # POST /posts
  # POST /posts.json
  def create
    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_posts_path, notice: I18n.t('admin.posts.notice.create') }
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
    return respond_to_publish if publishing?

    respond_to do |format|
      if @post.update(@sanitized_params)
        format.html { redirect_to admin_posts_path, notice: I18n.t('admin.posts.notice.update') }
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
      format.html { redirect_to admin_posts_path, notice: I18n.t('admin.posts.notice.destroy') }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize Post
  end

  def find_collection
    @scope = (params[:scope] || 'all').to_sym
    @page  = params[:page]
    @posts = policy_scope(Post).send(@scope).page(@page)
  end

  def find_instance
    @post = Post.find(params[:id])
  end

  def build_new_instance
    @post = Post.new
  end

  def build_new_instance_from_params
    @post = Post.new(@sanitized_params)
  end

  def authorize_instance
    authorize @post
  end

  def sanitize_params
    fetched = instance_params

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

  def instance_params
    params.fetch(:post, {}).permit(
      :body,
      :title,
      :work_id,
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
          :creator_id,
          :creator_attributes => [
            :contribution_id,
            :id,
            :_destroy,
            :name
          ]
        ]
      ]
    )
  end

  def prepare_form
    prepare_work_attributes_fields
    prepare_dropdowns

    @selected_tab = which_tab
  end

  def prepare_work_attributes_fields
    if @post.persisted? || @post.work_id.present?
      @allow_new_work = false
    else
      @allow_new_work = true

      @post.build_work unless @post.work.present?
      @post.work.prepare_contributions
    end
  end

  def prepare_dropdowns
    @works = Work.grouped_select_options_for_post

    return unless @allow_new_work

    @creators = policy_scope(Creator)
    @roles    = Contribution.human_roles
  end

  def which_tab
    case action_name
    when 'new'
      return 'post-choose-work'
    when 'create'
      if @sanitized_params[:work_attributes].present?
        return 'post-new-work'
      elsif @sanitized_params[:title].present?
        return 'post-standalone'
      else
        return 'post-choose-work'
      end
    when 'edit', 'update'
      if @post.title.present?
        return 'post-standalone'
      else
        return 'post-choose-work'
      end
    end
  end

  def publishing?
    params[:step] == 'publish'
  end

  def respond_to_publish
    saved     = @post.update(@sanitized_params) 

    begin
      published = @post.publish!
    rescue AASM::InvalidTransition => err
      published = false
    end

    respond_to do |format|
      if saved && published
        format.html { redirect_to admin_posts_path, notice: I18n.t('admin.posts.notice.publish') }
        format.json { render :show, status: :ok, location: @post }
      else
        prepare_form

        flash.now[:error] = I18n.t('admin.posts.error.publish') unless published

        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
end
