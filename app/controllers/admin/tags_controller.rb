class Admin::TagsController < Admin::BaseController

  # GET /admin/tags
  # GET /admin/tags.json
  def index; end

  # GET /admin/tags/1
  # GET /admin/tags/1.json
  def show; end

  # GET /admin/tags/new
  def new; end

  # POST /admin/tags
  # POST /admin/tags.json
  def create
    respond_to do |format|
      if @tag.save
        format.html { redirect_to admin_tag_path(@tag), success: I18n.t("admin.flash.tags.success.create") }
        format.json { render :show, status: :created, location: admin_tag_url(@tag) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/tags/1/edit
  def edit; end

  # PATCH/PUT /admin/tags/1
  # PATCH/PUT /admin/tags/1.json
  def update
    respond_to do |format|
      if @tag.update(instance_params)
        format.html { redirect_to admin_tag_path(@tag), success: I18n.t("admin.flash.tags.success.update") }
        format.json { render :show, status: :ok, location: admin_tag_url(@tag) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to admin_tags_path, success: I18n.t("admin.flash.tags.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @tags = scoped_and_sorted_collection
  end

  def build_new_instance
    @tag = Tag.new(instance_params)
  end

  def find_instance
    @tag = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @tag
  end

  def instance_params
    params.fetch(:tag, {}).permit(
      :name,
    )
  end

  def prepare_form
    @work_types = Work.type_options
  end

  def allowed_sorts
    name_sort   = "LOWER(tags.name) ASC"

    super(name_sort).merge({
      "Name" => [name_sort].join(", "),
    })
  end
end
