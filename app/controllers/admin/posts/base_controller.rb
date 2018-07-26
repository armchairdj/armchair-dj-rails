# frozen_string_literal: true

class Admin::Posts::BaseController < Admin::BaseController
  before_action :require_ajax, only: :autosave

  skip_before_action :authorize_instance, only: [:update]

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
    @instance.attributes = post_params_for_update

    authorize_instance

    respond_to do |format|
      if @instance.save
        format.html { redirect_to show_path, success: flash_for_update }
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
    if @post.changing_publication_status?
      authorize(@post, :publish?)
    else
      authorize(@post)
    end
  end

  def fetch_params(permitted)
    params.fetch(controller_name.singularize.to_sym, {}).permit(permitted)
  end

  def post_params_for_create
    fetch_params(keys_for_create).merge(author: current_user)
  end

  def post_params_for_autosave
    fetch_params(keys_for_create + keys_for_update)
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
    when "scheduled"; [:unscheduling]
    when "published"; [:clear_slug, :unpublishing]
    end
  end

  def prepare_form
    if @instance.persisted?
      @instance.prepare_links

      @tags = Tag.alpha
    end
  end

  def flash_for_update
    I18n.t("admin.flash.posts.success.update", flash_for_update_action_name)
  end

  def flash_for_update_action_name
    return "published"   if @instance.publishing?
    return "unpublished" if @instance.unpublishing?
    return "scheduled"   if @instance.scheduling?
    return "unscheduled" if @instance.unscheduling?
    return "updated"
  end
end
