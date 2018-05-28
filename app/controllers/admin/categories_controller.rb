class Admin::CategoriesController < AdminController
  before_action :find_collection, only: [
    :index
  ]

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

  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
  ]

  before_action :authorize_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  # GET /admin/categories
  # GET /admin/categories.json
  def index

  end

  # GET /admin/categories/1
  # GET /admin/categories/1.json
  def show

  end

  # GET /admin/categories/new
  def new

  end

  # POST /admin/categories
  # POST /admin/categories.json
  def create
    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_category_path(@category), success: I18n.t("admin.flash.categories.success.create") }
        format.json { render :show, status: :created, location: admin_category_url(@category) }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/categories/1/edit
  def edit

  end

  # PATCH/PUT /admin/categories/1
  # PATCH/PUT /admin/categories/1.json
  def update
    respond_to do |format|
      if @category.update(instance_params)
        format.html { redirect_to admin_category_path(@category), success: I18n.t("admin.flash.categories.success.update") }
        format.json { render :show, status: :ok, location: admin_category_url(@category) }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/categories/1
  # DELETE /admin/categories/1.json
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to admin_categories_path, success: I18n.t("admin.flash.categories.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @categories = scoped_and_sorted_collection
  end

  def build_new_instance
    @category = Category.new(instance_params)
  end

  def find_instance
    @category = Category.find(params[:id])
  end

  def authorize_instance
    authorize @category
  end

  def instance_params
    params.fetch(:category, {}).permit(
      :name,
      :format,
      :allow_multiple
    )
  end

  def allowed_scopes
    super.merge({
      "String" => :string,
      "Year"   => :year,
      "Multi"  => :multi,
      "Single" => :single,
    })
  end

  def allowed_sorts
    name_sort   = "LOWER(categories.name) ASC"
    format_sort = Category.alpha_order_clause_for(:format)
    multi_sort  = "categories.allow_multiple ASC"

    super(name_sort).merge({
      "Name"   => name_sort,
      "Format" => [format_sort, name_sort].join(", "),
      "Multi?" => [multi_sort,  name_sort].join(", "),
    })
  end
end
