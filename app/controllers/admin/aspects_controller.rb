class Admin::AspectsController < Admin::BaseController

  # GET /admin/aspects
  # GET /admin/aspects.json
  def index; end

  # GET /admin/aspects/1
  # GET /admin/aspects/1.json
  def show; end

  # GET /admin/aspects/new
  def new; end

  # POST /admin/aspects
  # POST /admin/aspects.json
  def create
    respond_to do |format|
      if @aspect.save
        format.html { redirect_to admin_aspect_path(@aspect), success: I18n.t("admin.flash.aspects.success.create") }
        format.json { render :show, status: :created, location: admin_aspect_url(@aspect) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @aspect.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/aspects/1/edit
  def edit; end

  # PATCH/PUT /admin/aspects/1
  # PATCH/PUT /admin/aspects/1.json
  def update
    respond_to do |format|
      if @aspect.update(instance_params)
        format.html { redirect_to admin_aspect_path(@aspect), success: I18n.t("admin.flash.aspects.success.update") }
        format.json { render :show, status: :ok, location: admin_aspect_url(@aspect) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @aspect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/aspects/1
  # DELETE /admin/aspects/1.json
  def destroy
    @aspect.destroy

    respond_to do |format|
      format.html { redirect_to admin_aspects_path, success: I18n.t("admin.flash.aspects.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @aspects = scoped_and_sorted_collection
  end

  def build_new_instance
    @aspect = Aspect.new(instance_params)
  end

  def find_instance
    @aspect = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @aspect
  end

  def instance_params
    params.fetch(:aspect, {}).permit(
      :name,
      :facet
    )
  end

  def prepare_form
    @facets = Aspect.human_facets
  end

  def allowed_sorts
    super.merge({
      "Facet" => [aspect_facet_sort, name_sort],
      "Name"  => [name_sort, aspect_facet_sort],
    })
  end
end
