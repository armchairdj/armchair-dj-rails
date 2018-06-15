# frozen_string_literal: true

class Admin::WorksController < AdminController
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
    return handle_work_type if params[:step] == "select_work_type"

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

private

  def find_collection
    @works = scoped_and_sorted_collection
  end

  def build_new_instance
    @work = Work.new(type: params[:work].try(:[], :type))

    @work.attributes = instance_params
  end

  def find_instance
    @work = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @work
  end

  def prepare_form
    @types = Work.type_options

    @work.prepare_links

    if @work.type.present?
      @work.prepare_credits
      @work.prepare_contributions

      @creators = Creator.all.alpha
      @roles    = Role.where(work_type: @work.model_name.name)
      @works    = @work.grouped_parent_dropdown_options
    end
  end

  def instance_params
    params.fetch(:work, {}).permit([
      :type,
      :parent_id,
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
      ]
    ])
  end

  def handle_work_type
    respond_to do |format|
      format.html { prepare_form; render :new }
      format.json { render json: @work.errors, status: :unprocessable_entity }
    end
  end

  def allowed_sorts
    title_sort   = "LOWER(works.title) ASC"
    creator_sort = "LOWER(creators.name) ASC"
    medium_sort  = "LOWER(works.type) ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Creator" => [creator_sort, title_sort].join(", "),
      "Medium"  => [medium_sort,  title_sort].join(", "),
    })
  end
end
