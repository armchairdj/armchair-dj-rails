# frozen_string_literal: true

class Admin::CreatorsController < AdminController
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

  # GET /creators
  # GET /creators.json
  def index

  end

  # GET /creators/1
  # GET /creators/1.json
  def show

  end

  # GET /creators/new
  def new

  end

  # GET /creators/1/edit
  def edit

  end

  # POST /creators
  # POST /creators.json
  def create
    respond_to do |format|
      if @creator.save
        format.html { redirect_to admin_creator_path(@creator), success: I18n.t("admin.flash.creators.success.create") }
        format.json { render :show, status: :created, location: @creator }
      else
        prepare_form

        format.html { render :new }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /creators/1
  # PATCH/PUT /creators/1.json
  def update
    respond_to do |format|
      if @creator.update(instance_params)
        format.html { redirect_to admin_creator_path(@creator), success: I18n.t("admin.flash.creators.success.update") }
        format.json { render :show, status: :ok, location: @creator }
      else
        prepare_form

        format.html { render :edit }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creators/1
  # DELETE /creators/1.json
  def destroy
    @creator.destroy

    respond_to do |format|
      format.html { redirect_to admin_creators_path, success: I18n.t("admin.flash.creators.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @creators = scoped_and_sorted_collection
  end

  def build_new_instance
    @creator = Creator.new(instance_params)
  end

  def find_instance
    @creator = Creator.find(params[:id])
  end

  def authorize_instance
    authorize @creator
  end

  def instance_params
    params.fetch(:creator, {}).permit(
      :name,
      :summary,
      :primary,
      :collective,
      :identities_attributes => [
        :creator_id,
        :id,
        :_destroy,
        :pseudonym_id
      ],
      :memberships_attributes => [
        :creator_id,
        :id,
        :_destroy,
        :member_id
      ]
    )
  end

  def prepare_form
    @creator.prepare_identities
    @creator.prepare_memberships

    @singular_creators  = policy_scope(Creator).singular.alphabetical
    @secondary_creators = policy_scope(Creator).secondary.alphabetical
  end
end
