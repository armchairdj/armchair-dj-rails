# frozen_string_literal: true

class Admin::ArticlesController < AdminController
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

  before_action :authorize_instance, only: [
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

  before_action :prepare_form, only: [
    :new,
    :edit
  ]

  # GET /articles
  # GET /articles.json
  def index; end

  # GET /articles/1
  # GET /articles/1.json
  def show; end

  # GET /articles/new
  def new; end

  # POST /articles
  # POST /articles.json
  def create
    @article.attributes = @sanitized_params

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_article_path(@article), success: I18n.t("admin.flash.posts.success.create") }
        format.json { render :show, status: :created, location: admin_article_url(@article) }
      else
        prepare_form

        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /articles/1/edit
  def edit; end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
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

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_path, success: I18n.t("admin.flash.posts.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @articles = scoped_and_sorted_collection
  end

  def build_new_instance
    @article = Article.new
  end

  def find_instance
    @article = scoped_instance(params[:id])
  end

  def sanitize_create_params
    fetched = instance_params

    fetched.delete(:publish_on)

    @sanitized_params = fetched.merge(author: current_user)
  end

  def sanitize_update_params
    @sanitized_params = instance_params
  end

  def instance_params
    params.fetch(:article, {}).permit(
      :title,
      :body,
      :summary,
      :publish_on,
      :tag_ids => [],
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ]
    )
  end

  def prepare_form
    @article.prepare_links

    @tags = Tag.for_admin.alpha
  end

  def authorize_instance
    publishing? ? authorize(@article, :publish?) : authorize(@article)
  end

  def publishing?
    return false unless %w(edit update                          ).include? action_name
    return false unless %w(publish unpublish schedule unschedule).include? params[:step]
    return true
  end

  def respond_to_update(update_method, success, success_method = nil, failure = nil)
    respond_to do |format|
      if @article.send(update_method, @sanitized_params)
        format.html { redirect_to admin_article_path(@article), success: I18n.t(success) }
        format.json { render :show, status: :ok, location: admin_article_url(@article) }
      else
        prepare_form

        if success_method
          if @article.send(success_method)
            flash.now[:success] = I18n.t(success)
          else
            flash.now[:error  ] = I18n.t(failure)
          end
        end

        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def allowed_scopes
    super.reverse_merge({
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published
    })
  end

  def allowed_sorts
    title_sort  = "posts.alpha ASC"
    status_sort = "posts.status ASC"
    author_sort = "users.alpha ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
