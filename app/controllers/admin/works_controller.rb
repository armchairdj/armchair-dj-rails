# frozen_string_literal: true

class Admin::WorksController < AdminController
  # GET /works
  # GET /works.json
  def index

  end

  # GET /works/1
  # GET /works/1.json
  def show

  end

  # GET /works/new
  def new

  end

  # POST /works
  # POST /works.json
  def create
    respond_to do |format|
      if @work.save
        format.html { redirect_to admin_work_path(@work), success: I18n.t("admin.flash.works.success.create") }
        format.json { render :show, status: :created, location: @work }
      else
        prepare_form

        format.html { render(:new) }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /works/1/edit
  def edit

  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(instance_params)
        format.html { redirect_to admin_work_path(@work), success: I18n.t("admin.flash.works.success.update") }
        format.json { render :show, status: :ok, location: @work }
      else
        prepare_form

        format.html { render :edit }
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
    @work = Work.new(instance_params)
  end

  def find_instance
    @work = Work.find(params[:id])
  end

  def authorize_instance
    authorize @work
  end

  def prepare_form
    @work.prepare_credits
    @work.prepare_contributions

    @creators = policy_scope(Creator).alpha
    @roles    = policy_scope(Role).grouped_options
    @media    = policy_scope(Media).alpha
  end

  def instance_params
    params.fetch(:work, {}).permit(
      :medium_id,
      :title,
      :subtitle,
      :summary,
      :credits_attributes => [
        :id,
        :_destroy,
        :work_id,
        :creator_id
      ],
      :contributions_attributes => [
        :id,
        :_destroy,
        :work_id,
        :creator_id,
        :role_id,
      ]
    )
  end
end
