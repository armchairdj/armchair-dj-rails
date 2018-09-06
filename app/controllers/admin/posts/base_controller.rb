# frozen_string_literal: true

class Admin::Posts::BaseController < Ginsu::Controller
  before_action :require_ajax, only: :autosave

  skip_before_action :authorize_instance, only: [:update]

  # POST /admin/{collection}
  # POST /admin/{collection}.json
  def create
    @instance.attributes = post_params_for_create

    respond_to do |format|
      if @instance.save
        format.html { redirect_to edit_path, success: create_message }
        format.json { render :show, status: :created, location: show_path }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/{collection}/1
  # PATCH/PUT /admin/{collection}/1.json
  def update
    @instance.attributes = post_params_for_update

    authorize_instance

    return handle_preview if params[:step] == "preview"

    flash_message = update_message

    respond_to do |format|
      if @instance.save
        format.html { redirect_to show_path, success: flash_message }
        format.json { render :show, status: :created, location: show_path }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/{collection}/1/autosave.json
  def autosave
    @instance.attributes = post_params_for_autosave

    @instance.save!(validate: false)

    render json: {}, status: :ok
  end

  # DELETE /admin/posts/1
  # DELETE /admin/{collection}/1.json
  def destroy
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: destroy_message }
      format.json { head :no_content }
    end
  end

private

  #############################################################################
  # Find, build & authorize.
  #############################################################################

  def build_new_instance
    @post = super
  end

  def find_instance
    @post = super
  end

  def authorize_instance
    if @post.changing_publication_status?
      authorize(@post, :publish?)
    elsif params[:step] == "preview"
      authorize(@post, :preview?)
    else
      authorize(@post)
    end
  end

  #############################################################################
  # Params.
  #############################################################################

  def fetch_params(permitted)
    params.fetch(controller_name.singularize.to_sym, {}).permit(permitted)
  end

  def post_params_for_create
    fetch_params(keys_for_create).merge(author: current_user)
  end

  def post_params_for_autosave
    fetch_params(keys_for_create + keys_for_update)
  end

  def post_params_for_preview
    fetch_params(keys_for_create + keys_for_status_change + keys_for_update)
  end

  def post_params_for_update
    fetch_params(keys_for_create + keys_for_status_change + keys_for_update)
  end

  def keys_for_create
    raise NotImplementedError
  end

  def keys_for_update
    [:body, :summary, {
      tag_ids:          [],
      links_attributes: [:id, :_destroy, :url, :description]
    }]
  end

  def keys_for_status_change
    case @instance.status
    when "draft";     [:publishing, :scheduling, :publish_on]
    when "scheduled"; [:publishing, :unscheduling]
    when "published"; [:unpublishing, :clear_slug]
    end
  end

  #############################################################################
  # Rendering.
  #############################################################################

  def prepare_form
    return unless @instance.persisted?

    @instance.prepare_links

    @tags = Tag.alpha
  end

  def handle_preview
    render "posts/#{@instance.model_name.collection}/show"
  end

  #############################################################################
  # Flash messages.
  #############################################################################

  def create_message
    I18n.t("admin.flash.posts.success.create")
  end

  def update_message
    action = case
      when @instance.publishing?;   "updated & published"
      when @instance.unpublishing?; "updated & unpublished"
      when @instance.scheduling?;   "updated & scheduled"
      when @instance.unscheduling?; "updated & unscheduled"
      else "updated"
    end

    I18n.t("admin.flash.posts.success.update", action: action)
  end

  def destroy_message
    I18n.t("admin.flash.posts.success.destroy")
  end
end
