# frozen_string_literal: true

class Admin::Posts::BaseController < Admin::BaseController
  before_action :require_ajax, only: :autosave

  # POST /posts
  # POST /posts.json
  def create
    @instance.attributes = post_params_for_create

    respond_to do |format|
      if @instance.save
        format.html { redirect_to edit_path, success: I18n.t("admin.flash.posts.success.create") }
        format.json { render :show, status: :created, location: show_path }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    return handle_step if params[:step].present?

    respond_to do |format|
      if @instance.update(post_params_for_update)
        format.html { redirect_to show_path, success: I18n.t("admin.flash.posts.success.update") }
        format.json { render :show, status: :created, location: show_path }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def autosave
    find_instance
    authorize_instance

    begin
      @instance.attributes = post_params_for_autosave

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

  def build_new_instance
    @post = super
  end

  def find_instance
    @post = super
  end

  def authorize_instance
    authorize(@post, publishing? ? :publish? : nil)
  end

  def publishing?
    %w(edit update).include?(action_name) && params[:step].present?
  end

  def fetch_params(permitted)
    params.fetch(controller_name.singularize.to_sym, {}).permit(permitted)
  end

  def post_params_for_create
    fetch_params(initial_keys).merge(author: current_user)
  end

  def post_params_for_autosave
    fetch_params(initial_keys + draft_keys)
  end

  def post_params_for_update
    fetch_params(initial_keys + publish_keys + draft_keys)
  end

  def initial_keys
    raise NotImplementedError
  end

  def draft_keys
    [:body, :summary, {
      tag_ids:          [],
      links_attributes: [:id, :_destroy, :url, :description]
    }]
  end

  def publish_keys
    @instance.published? ? [:clear_slug] : [:publish_on]
  end

  def prepare_form
    if @instance.persisted?
      @instance.prepare_links

      @tags = Tag.alpha
    end
  end

  def prepare_show
    @tags  = @instance.tags.alpha
    @links = @instance.links
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
      if @instance.send(@update_method, post_params_for_update)
        format.html { redirect_to show_path, success: success_flash }
        format.json { render :show, status: :ok, location: show_path }
      else
        format.html { prepare_form; set_publication_flash; render :edit }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_publication_flash
    if @instance.send(@success_test)
      flash.now[:success] = success_flash
    else
      flash.now[:error] = error_flash
    end
  end

  def success_flash
    # admin.flash.posts.success.publish
    # admin.flash.posts.success.unpublish
    # admin.flash.posts.success.schedule
    # admin.flash.posts.success.unschedule
    I18n.t("admin.flash.posts.success.#{@flash_key}")
  end

  def error_flash
    # admin.flash.posts.error.publish
    # admin.flash.posts.error.unpublish
    # admin.flash.posts.error.schedule
    # admin.flash.posts.error.unschedule
    I18n.t("admin.flash.posts.error.#{@flash_key}")
  end

  def allowed_scopes
    {
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published
    }
  end

  def allowed_sorts
    {
      "Title"   => alpha_sort,
      "Status"  => [post_status_sort,   alpha_sort],
      "Author"  => [user_username_sort, alpha_sort],
    }
  end

  def post_status_sort
    "posts.status ASC"
  end
end
