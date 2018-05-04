class Admin::MediaController < AdminController
  # GET /admin/media
  # GET /admin/media.json
  def index

  end

  # GET /admin/media/1
  # GET /admin/media/1.json
  def show

  end

  # GET /admin/media/new
  def new

  end

  # POST /admin/media
  # POST /admin/media.json
  def create
    respond_to do |format|
      if @medium.save
        format.html { redirect_to @medium, success: I18n.t("#{singular_table_name}.success.create") }
        format.json { render :show, status: :created, location: @medium }
      else
        format.html { render :new }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/media/1/edit
  def edit

  end

  # PATCH/PUT /admin/media/1
  # PATCH/PUT /admin/media/1.json
  def update
    respond_to do |format|
      if @medium.update(instance_params)
        format.html { redirect_to @medium, success: I18n.t("#{singular_table_name}.success.update") }
        format.json { render :show, status: :ok, location: @medium }
      else
        format.html { render :edit }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/media/1
  # DELETE /admin/media/1.json
  def destroy
    @medium.destroy

    respond_to do |format|
      format.html { redirect_to media_url, success: I18n.t("#{singular_table_name}.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @media = scoped_and_sorted_collection
  end

  def build_new_instance
    @medium = Medium.new(instance_params)
  end

  def find_instance
    @medium = Medium.find(params[:id])
  end

  def authorize_instance
    authorize @medium
  end

  def instance_params
    params.fetch(:medium, {})
  end
end
