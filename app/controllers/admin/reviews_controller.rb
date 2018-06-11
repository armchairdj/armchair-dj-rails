# frozen_string_literal: true

class Admin::ReviewsController < AdminController
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

  # GET /reviews
  # GET /reviews.json
  def index; end

  # GET /reviews/1
  # GET /reviews/1.json
  def show; end

  # GET /reviews/new
  def new; end

  # POST /reviews
  # POST /reviews.json
  def create
    @review.attributes = @sanitized_params

    respond_to do |format|
      if @review.save
        format.html { redirect_to admin_review_path(@review), success: I18n.t("admin.flash.posts.success.create") }
        format.json { render :show, status: :created, location: admin_review_url(@review) }
      else
        prepare_form

        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /reviews/1/edit
  def edit; end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
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

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to admin_reviews_path, success: I18n.t("admin.flash.posts.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @reviews = scoped_and_sorted_collection
  end

  def build_new_instance
    @review = Review.new
  end

  def find_instance
    @review = scoped_instance(params[:id])
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
    params.fetch(:review, {}).permit(
      :work_id,
      :body,
      :summary,
      :publish_on,
      :tag_ids => [],
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ],
      :work_attributes => [
        :id,
        :review_id,
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
    @selected_tab = determine_selected_tab

    @review.prepare_links

    @review.prepare_work_for_editing(@sanitized_params)

    @creators = Creator.all.alpha
    @tags     = Tag.for_admin.alpha
    @works    = Work.grouped_options
  end

  def authorize_instance
    publishing? ? authorize(@review, :publish?) : authorize(@review)
  end

  def publishing?
    return false unless %w(edit update                          ).include? action_name
    return false unless %w(publish unpublish schedule unschedule).include? params[:step]
    return true
  end

  def determine_selected_tab
    case action_name
    when "new", "edit"
      "review-choose-work"
      "review-choose-work"
    when "create", "update"
      if @sanitized_params[:work_attributes].present?
        "review-new-work"
      else
        "review-choose-work"
      end
    end
  end

  def respond_to_update(update_method, success, success_method = nil, failure = nil)
    respond_to do |format|
      if @review.send(update_method, @sanitized_params)
        format.html { redirect_to admin_review_path(@review), success: I18n.t(success) }
        format.json { render :show, status: :ok, location: admin_review_url(@review) }
      else
        prepare_form

        if success_method
          if @review.send(success_method)
            flash.now[:success] = I18n.t(success)
          else
            flash.now[:error  ] = I18n.t(failure)
          end
        end

        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def allowed_scopes
    super.reverse_merge({
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published,
    })
  end

  def allowed_sorts
    title_sort  = "posts.alpha ASC"
    status_sort = "posts.status ASC"
    author_sort = "users.alpha ASC"
    type_sort   = "LOWER(works.type) ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Type"    => [type_sort,   title_sort].join(", "),
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
