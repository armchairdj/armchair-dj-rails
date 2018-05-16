# frozen_string_literal: true

class Admin::WorksController < AdminController
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

  before_action :prepare_form, only: [
    :new,
    :edit
  ]

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
    return handle_medium if params[:step] == "select_medium"

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
    @work.attributes = instance_params.merge(permitted_tag_params)

    respond_to do |format|
      if @work.save
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

    @work.attributes = permitted_tag_params
  end

  def find_instance
    @work = Work.find(params[:id])
  end

  def authorize_instance
    authorize @work
  end

  def prepare_form
    @media = Medium.all.alpha

    if @work.medium.present?
      @work.prepare_credits
      @work.prepare_contributions

      @creators   = Creator.all.alpha
      @roles      = Role.options_for(@work.medium)
      @categories = @work.medium.tags_by_category
    end
  end

  def instance_params
    params.fetch(:work, {}).permit([
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
    ])
  end

  def permitted_tag_params
    params.fetch(:work, {}).permit([
      @work.permitted_tag_params
    ])
  end

  def handle_medium
    respond_to do |format|
      prepare_form

      format.html { render :new }
      format.json { render json: @work.errors, status: :unprocessable_entity }
    end
  end
end
