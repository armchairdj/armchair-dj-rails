# frozen_string_literal: true

module Admin
  class WorksController < Ginsu::Controller
    before_action :require_ajax, only: :reorder_credits

    # POST /works
    # POST /works.json
    def create
      return handle_medium if params[:step] == "select_medium"

      @work.attributes = instance_params

      respond_to do |format|
        if @work.save
          format.html { redirect_to show_path, success: I18n.t("admin.flash.works.success.create") }
          format.json { render :show, status: :created, location: admin_work_url(@work) }
        else
          format.html { render_new }
          format.json { render json: @work.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /works/1
    # PATCH/PUT /works/1.json
    def update
      @work.attributes = instance_params

      respond_to do |format|
        if @work.save
          format.html { redirect_to show_path, success: I18n.t("admin.flash.works.success.update") }
          format.json { render :show, status: :ok, location: admin_work_url(@work) }
        else
          format.html { render_edit }
          format.json { render json: @work.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /works/1
    # DELETE /works/1.json
    def destroy
      @work.destroy

      respond_to do |format|
        format.html { redirect_to collection_path, success: I18n.t("admin.flash.works.success.destroy") }
        format.json { head :no_content }
      end
    end

    # POST /admin/works/1/reorder_credits
    def reorder_credits
      Credit.reorder_for!(@work, params[:credit_ids])

      render json: {}, status: :ok
    end

  private

    def build_new_instance
      @instance = @work = Work.new(medium: params[:work].try(:[], :medium))
    end

    def handle_medium
      respond_to do |format|
        format.html { render_new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end

    def prepare_form
      @work.prepare_for_editing

      @media = Work.media

      return unless @work.medium.present?

      @creators  = Creator.all.alpha
      @roles     = @work.available_roles
      @relatives = @work.available_relatives
    end

    def instance_params
      params.fetch(:work, {}).permit([
        :medium,
        :title,
        :subtitle,
        :hero_image,
        additional_images:               [],
        aspect_ids:                      [],
        links_attributes:                [
          :id,
          :_destroy,
          :url,
          :description
        ],
        credits_attributes:              [
          :id,
          :_destroy,
          :work_id,
          :creator_id
        ],
        contributions_attributes:        [
          :id,
          :_destroy,
          :work_id,
          :creator_id,
          :role_id
        ],
        milestones_attributes:           [
          :id,
          :_destroy,
          :work_id,
          :activity,
          :year
        ],
        source_relationships_attributes: [
          :id,
          :_destroy,
          :target_id,
          :connection,
          :source_id
        ],
        target_relationships_attributes: [
          :id,
          :_destroy,
          :source_id,
          :connection,
          :target_id
        ]
      ])
    end
  end
end
