# frozen_string_literal: true

class Admin::MixtapesController < AdminController
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

  # GET /mixtapes
  # GET /mixtapes.json
  def index; end

  # GET /mixtapes/1
  # GET /mixtapes/1.json
  def show; end

  # GET /mixtapes/new
  def new; end

  # POST /mixtapes
  # POST /mixtapes.json
  def create
    @mixtape.attributes = @sanitized_params

    respond_to do |format|
      if @mixtape.save
        format.html { redirect_to admin_mixtape_path(@mixtape), success: I18n.t("admin.flash.posts.success.create") }
        format.json { render :show, status: :created, location: admin_mixtape_url(@mixtape) }
      else
        prepare_form

        format.html { render :new }
        format.json { render json: @mixtape.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /mixtapes/1/edit
  def edit; end

  # PATCH/PUT /mixtapes/1
  # PATCH/PUT /mixtapes/1.json
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

  # DELETE /mixtapes/1
  # DELETE /mixtapes/1.json
  def destroy
    @mixtape.destroy

    respond_to do |format|
      format.html { redirect_to admin_mixtapes_path, success: I18n.t("admin.flash.posts.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @mixtapes = scoped_and_sorted_collection
  end

  def build_new_instance
    @mixtape = Mixtape.new
  end

  def find_instance
    @mixtape = scoped_instance(params[:id])
  end

  def sanitize_create_params
    fetched = instance_params

    fetched.delete(:slug)
    fetched.delete(:publish_on)

    @sanitized_params = fetched.merge(author: current_user)
  end

  def sanitize_update_params
    @sanitized_params = instance_params
  end

  def instance_params
    params.fetch(:mixtape, {}).permit(
      :playlist_id,
      :body,
      :summary,
      :slug,
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
    @mixtape.prepare_links

    @tags      = Tag.for_admin.alpha
    @playlists = Playlist.for_admin.alpha
  end

  def authorize_instance
    publishing? ? authorize(@mixtape, :publish?) : authorize(@mixtape)
  end

  def publishing?
    return false unless %w(edit update                          ).include? action_name
    return false unless %w(publish unpublish schedule unschedule).include? params[:step]
    return true
  end

  def respond_to_update(update_method, success, success_method = nil, failure = nil)
    respond_to do |format|
      if @mixtape.send(update_method, @sanitized_params)
        format.html { redirect_to admin_mixtape_path(@mixtape), success: I18n.t(success) }
        format.json { render :show, status: :ok, location: admin_mixtape_url(@mixtape) }
      else
        prepare_form

        if success_method
          if @mixtape.send(success_method)
            flash.now[:success] = I18n.t(success)
          else
            flash.now[:error  ] = I18n.t(failure)
          end
        end

        format.html { render :edit }
        format.json { render json: @mixtape.errors, status: :unprocessable_entity }
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
    title_sort  = "mixtapes.alpha ASC"
    status_sort = "mixtapes.status ASC"
    author_sort = "users.alpha ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
