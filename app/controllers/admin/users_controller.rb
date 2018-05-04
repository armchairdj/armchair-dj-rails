# frozen_string_literal: true

class Admin::UsersController < AdminController
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

  # GET /users
  # GET /users.json
  def index

  end

  # GET /users/1
  # GET /users/1.json
  def show

  end

  # GET /users/new
  def new

  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user), success: I18n.t("admin.flash.users.success.create") }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(instance_params)
        format.html { redirect_to admin_user_path(@user), success: I18n.t("admin.flash.users.success.update") }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path, success: I18n.t("admin.flash.users.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @users = scoped_and_sorted_collection
  end

  def build_new_instance
    @user = User.new(instance_params)
  end

  def find_instance
    @user = User.find(params[:id])
  end

  def authorize_instance
    authorize @user
  end

  def instance_params
    params.fetch(:user, {}).permit(
      :first_name,
      :last_name,
      :middle_name,
      :email,
      :username,
      :password,
      :role,
      :bio
    )
  end
end
