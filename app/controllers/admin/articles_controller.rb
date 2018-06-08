# frozen_string_literal: true

class Admin::ArticlesController < AdminController
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
        format.html { redirect_to admin_article_path(@article), success: I18n.t("admin.flash.articles.success.create") }
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
      respond_to_update :update_and_publish,    "admin.flash.articles.success.publish",    :published?, "admin.flash.articles.error.publish"
    when "unpublish"
      respond_to_update :update_and_unpublish,  "admin.flash.articles.success.unpublish",  :draft?,     "admin.flash.articles.error.unpublish"
    when "schedule"
      respond_to_update :update_and_schedule,   "admin.flash.articles.success.schedule",   :scheduled?, "admin.flash.articles.error.schedule"
    when "unschedule"
      respond_to_update :update_and_unschedule, "admin.flash.articles.success.unschedule", :draft?,     "admin.flash.articles.error.unschedule"
    else
      respond_to_update :update,                "admin.flash.articles.success.update"
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_path, success: I18n.t("admin.flash.articles.success.destroy") }
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

    if @article.standalone?
      fetched.delete(:work_attributes)
      fetched.delete(:work_id)
    elsif @article.review?
      fetched.delete(:title)
    end

    @sanitized_params = fetched
  end

  def instance_params
    params.fetch(:article, {}).permit(
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
        :article_id,
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
    @available_tabs = determine_available_tabs
    @selected_tab   = determine_selected_tab

    @article.prepare_links

    return if @article.persisted? && @article.standalone?

    @article.prepare_work_for_editing(@sanitized_params)

    @creators = Creator.all.alpha
    @media    = Medium.all.alpha
    @tags     = Tag.for_articles
    @works    = Work.grouped_options
  end

  def authorize_instance
    publishing? ? authorize(@article, :publish?) : authorize(@article)
  end

  def publishing?
    return false unless %w(edit update                          ).include? action_name
    return false unless %w(publish unpublish schedule unschedule).include? params[:step]
    return true
  end

  def determine_available_tabs
    case action_name
    when "new", "create"
      ["article-choose-work", "article-new-work", "article-standalone"]
    when "edit", "update"
      if @article.standalone?
        ["article-standalone"]
      else
        ["article-choose-work", "article-new-work"]
      end
    end
  end

  def determine_selected_tab
    case action_name
    when "new"
      "article-choose-work"
    when "create"
      if @sanitized_params[:work_attributes].present?
        "article-new-work"
      elsif @sanitized_params[:title].present?
        "article-standalone"
      else
        "article-choose-work"
      end
    when "edit"
      if @article.standalone?
        "article-standalone"
      else
        "article-choose-work"
      end
    when "update"
      if @article.standalone?
        "article-standalone"
      elsif @sanitized_params[:work_attributes].present?
        "article-new-work"
      else
        "article-choose-work"
      end
    end
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
      "Published"  => :published,
      "Review"     => :review,
      "Article"       => :standalone,
    })
  end

  def allowed_sorts
    title_sort  = "articles.alpha ASC"
    type_sort   = "LOWER(media.name) ASC"
    status_sort = "articles.status ASC"
    author_sort = "users.alpha ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Type"    => [type_sort,   title_sort].join(", "),
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
