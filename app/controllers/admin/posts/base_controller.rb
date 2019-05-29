# frozen_string_literal: true

module Admin
  module Posts
    class BaseController < Ginsu::Controller
      before_action :set_view_path

      # GET /admin/{collection}/new
      def new
        render_new
      end

      # GET /admin/{collection}/1/edit
      def edit
        render_edit
      end

      # POST /admin/{collection}
      # POST /admin/{collection}.json
      def create
        @instance.attributes = post_params_for_create

        respond_to do |format|
          if @instance.save
            format.html { redirect_to edit_path, success: create_message }
            format.json { render :show, status: :created, location: show_path }
          else
            format.html { render_new }
            format.json { render json: @instance.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /admin/{collection}/1
      # PATCH/PUT /admin/{collection}/1.json
      def update
        @instance.attributes = post_params_for_update

        flash_message = update_message

        respond_to do |format|
          if @instance.save
            format.html { redirect_to show_path, success: flash_message }
            format.json { render :show, status: :created, location: show_path }
          else
            format.html { render_edit }
            format.json { render json: @instance.errors, status: :unprocessable_entity }
          end
        end
      end

      # GET /admin/{collection}/1/preview
      # GET /admin/{collection}/1/preview.json
      def preview
        render_preview
      end

      # PATCH/PUT /admin/{collection}/1/autosave.json
      def autosave
        require_ajax

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
        when "draft"     then [:publishing, :scheduling, :publish_on]
        when "scheduled" then [:publishing, :unscheduling]
        when "published" then [:unpublishing, :clear_slug]
        end
      end

      #############################################################################
      # Rendering.
      #############################################################################

      def set_view_path
        @view_path = controller_name
      end

      def prepare_form
        return unless @instance.persisted?

        @instance.prepare_links

        @tags = Tag.alpha
      end

      def render_index
        render "admin/posts/index"
      end

      def render_show
        prepare_show

        render "admin/posts/show"
      end

      def render_new
        prepare_form

        render "admin/posts/new"
      end

      def render_edit
        prepare_form

        render "admin/posts/edit"
      end

      def render_preview
        render "admin/posts/preview"
      end

      #############################################################################
      # Flash messages.
      #############################################################################

      def create_message
        I18n.t("admin.flash.posts.success.create")
      end

      def update_message
        action = if @instance.publishing? then "updated & published"
        elsif @instance.unpublishing? then "updated & unpublished"
        elsif @instance.scheduling?   then "updated & scheduled"
        elsif @instance.unscheduling? then "updated & unscheduled"
        else "updated"
        end

        I18n.t("admin.flash.posts.success.update", action: action)
      end

      def destroy_message
        I18n.t("admin.flash.posts.success.destroy")
      end
    end
  end
end
