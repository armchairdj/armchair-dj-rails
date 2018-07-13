# frozen_string_literal: true

class Admin::WorksController < Admin::BaseController
  before_action :require_ajax, only: :reorder_credits

  # GET /works
  # GET /works.json
  def index; end

  # GET /works/1
  # GET /works/1.json
  def show; end

  # GET /works/new
  def new; end

  # POST /works
  # POST /works.json
  def create
    return handle_medium if params[:step] == "select_medium"

    respond_to do |format|
      if @work.save
        format.html { redirect_to admin_work_path(@work), success: I18n.t("admin.flash.works.success.create") }
        format.json { render :show, status: :created, location: admin_work_url(@work) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /works/1/edit
  def edit; end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    @work.attributes = instance_params

    respond_to do |format|
      if @work.save
        format.html { redirect_to admin_work_path(@work), success: I18n.t("admin.flash.works.success.update") }
        format.json { render :show, status: :ok, location: admin_work_url(@work) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    @work.destroy

    respond_to do |format|
      format.html { redirect_to admin_works_path, success: I18n.t("admin.flash.works.success.destroy") }
      format.json { head :no_content }
    end
  end

  # POST /admin/works/1/reorder_credits
  def reorder_credits
    find_instance
    authorize @work, :update?

    Credit.reorder_for!(@work, params[:credit_ids])

    render json: {}, status: :ok
  end

private

  def find_collection
    @works = scoped_and_sorted_collection
  end

  def build_new_instance
    @work = Work.new(medium: params[:work].try(:[], :medium))

    @work.attributes = instance_params
  end

  def find_instance
    @work = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @work
  end

  def prepare_form
    @media = Work.media

    if @work.medium.present?
      @work.prepare_credits
      @work.prepare_contributions
      @work.prepare_milestones

      @creators = Creator.all.alpha
      @roles    = @work.available_roles
    end
  end

  def instance_params
    params.fetch(:work, {}).permit([
      :medium,
      :title,
      :subtitle,
      aspect_ids: [],
      links_attributes: [
        :id,
        :_destroy,
        :url,
        :description
      ],
      credits_attributes: [
        :id,
        :_destroy,
        :work_id,
        :creator_id
      ],
      contributions_attributes: [
        :id,
        :_destroy,
        :work_id,
        :creator_id,
        :role_id,
      ],
      milestones_attributes: [
        :id,
        :_destroy,
        :work_id,
        :activity,
        :year,
      ],
    ])
  end

  def handle_medium
    respond_to do |format|
      format.html { prepare_form; render :new }
      format.json { render json: @work.errors, status: :unprocessable_entity }
    end
  end

  def allowed_sorts
    super.merge({
      "Title"   => title_sort,
      "Makers" =>  [creator_name_sort, title_sort],
      "Medium"  => [work_medium_sort,  title_sort],
    })
  end
end
