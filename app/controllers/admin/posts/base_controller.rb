# frozen_string_literal: true

class Admin::Posts::BaseController < Admin::BaseController
  before_action :require_ajax, only: :autosave

  # GET /posts
  # GET /posts.json
  def index; end

  # GET /posts/1
  # GET /posts/1.json
  def show; end

  # GET /posts/new
  def new; end

  # POST /posts
  # POST /posts.json
  def create
    @instance.attributes = create_params

    respond_to do |format|
      if @instance.save
        format.html { redirect_to instance_path, success: I18n.t("admin.flash.posts.success.create") }
        format.json { render :show, status: :created, location: instance_path(full_url: true) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /posts/1/edit
  def edit; end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    return handle_step if params[:step].present?

    respond_to do |format|
      if @instance.update(update_params)
        format.html { redirect_to instance_path, success: I18n.t("admin.flash.posts.success.update") }
        format.json { render :show, status: :created, location: instance_path(full_url: true) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def autosave
    find_instance
    authorize @instance, :update?

    begin
      @instance.attributes = autosave_params

      @instance.save!(validate: false)

      render json: {}, status: :ok
    rescue => err
      handle_500(err)
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.posts.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @collection = scoped_and_sorted_collection

    instance_variable_set(:"@#{controller_name}", @collection)
  end

  def build_new_instance
    @post = @instance = model_class.new

    instance_variable_set(:"@#{controller_name.singularize}", @instance)
  end

  def find_instance
    @post = @instance = scoped_instance(params[:id])

    instance_variable_set(:"@#{controller_name.singularize}", @instance)
  end

  def authorize_instance
    authorize(@instance, publishing? ? :publish? : nil)
  end

  def publishing?
    %w(edit update).include?(action_name) && params[:step].present?
  end

  def create_params
    post_params(allow_publishing: false).merge(author: current_user)
  end

  def update_params
    post_params(allow_publishing: true)
  end

  def autosave_params
    post_params(allow_publishing: false)
  end

  def post_params(allow_publishing:)
    permitted = if allow_publishing
      permitted_keys.unshift(:publish_on, :clear_slug)
    else
      permitted_keys
    end

    params.fetch(controller_name.singularize.to_sym, {}).permit(permitted)
  end

  def permitted_keys
    [
      :body,
      :summary,
      {
        :tag_ids => [],
        :links_attributes => [
          :id,
          :_destroy,
          :url,
          :description
        ]
      }
    ]
  end

  def prepare_form
    @instance.prepare_links

    @tags = Tag.alpha
  end

  def prepare_show
    @tags   = @instance.tags.alpha
    @links  = @instance.links
  end

  def handle_step
    @update_method, @flash_key, @success_test = case params[:step]
    when "publish"
      [ :update_and_publish,    "publish",    :published? ]
    when "unpublish"
      [ :update_and_unpublish,  "unpublish",  :draft?     ]
    when "schedule"
      [ :update_and_schedule,   "schedule",   :scheduled? ]
    when "unschedule"
      [ :update_and_unschedule, "unschedule", :draft?     ]
    end

    update_state_and_respond
  end

  def update_state_and_respond
    respond_to do |format|
      if @instance.send(@update_method, update_params)
        format.html { redirect_to instance_path, success: success_flash }
        format.json { render :show, status: :ok, location: instance_path(full_url: true) }
      else
        format.html { prepare_form; set_publication_flash; render :edit }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_publication_flash
    @instance.send(@success_test) ? success_flash : error_flash
  end

  def success_flash
    # admin.flash.posts.success.publish
    # admin.flash.posts.success.unpublish
    # admin.flash.posts.success.schedule
    # admin.flash.posts.success.unschedule
    flash.now[:success] = I18n.t("admin.flash.posts.success.#{@flash_key}")
  end

  def error_flash
    # admin.flash.posts.error.publish
    # admin.flash.posts.error.unpublish
    # admin.flash.posts.error.schedule
    # admin.flash.posts.error.unschedule
    flash.now[:error] = I18n.t("admin.flash.posts.error.#{@flash_key}")
  end

  def allowed_scopes
    super.reverse_merge({
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published
    })
  end

  def allowed_sorts
    super.merge({
      "Title"   => alpha_sort,
      "Status"  => [post_status_sort,   alpha_sort],
      "Author"  => [user_username_sort, alpha_sort],
    })
  end

  def collection_path(full_url: false)
    case full_url
    when true;  polymorphic_url( [:admin, model_class])
    when false; polymorphic_path([:admin, model_class])
    end
  end

  def instance_path(full_url: false)
    case full_url
    when true;  polymorphic_url( [:admin, @instance])
    when false; polymorphic_path([:admin, @instance])
    end
  end
end
