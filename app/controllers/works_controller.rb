class WorksController < ApplicationController
  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
  ]

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

  before_action :authorize_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :prepare_contributions_attributes_fields, only: [
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
    respond_to do |format|
      if @work.save
        format.html { redirect_to @work, notice: I18n.t("work.notice.create") }
        format.json { render :show, status: :created, location: @work }
      else
        prepare_contributions_attributes_fields

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
        format.html { redirect_to @work, notice: I18n.t("work.notice.update") }
        format.json { render :show, status: :ok, location: @work }
      else
        prepare_contributions_attributes_fields

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
      format.html { redirect_to works_url, notice: I18n.t("work.notice.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize Work
  end

  def find_collection
    @works = policy_scope(Work)
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

  def prepare_contributions_attributes_fields
    @work.prepare_contributions

    @creators = policy_scope(Creator)
    @roles    = Contribution.human_enum_collection(:role)
  end

  def instance_params
    params.fetch(:work, {}).permit(
      :medium,
      :title,
      :body,
      :contributions_attributes => [
        :work_id,
        :id,
        :_destroy,
        :role,
        :creator_id
      ]
    )
  end
end
