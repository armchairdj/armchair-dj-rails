# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController

  # GET /users
  # GET /users.json
  def index; end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new; end

  # POST /users
  # POST /users.json
  def create
    respond_to do |format|
      if current_user.valid_role_assignment_for?(@user) && @user.save
        format.html { redirect_to admin_user_path(@user), success: I18n.t("admin.flash.users.success.create") }
        format.json { render :show, status: :created, location: admin_user_url(@user) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.attributes = instance_params

    respond_to do |format|
      if current_user.valid_role_assignment_for?(@user) && @user.save
        format.html { redirect_to admin_user_path(@user), success: I18n.t("admin.flash.users.success.update") }
        format.json { render :show, status: :ok, location: admin_user_url(@user) }
      else
        format.html { prepare_form; render :edit }
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
    @user = policy_scope(User).find_by(username: params[:id])
  end

  def authorize_instance
    authorize @user
  end

  def instance_params
    fetched = params.fetch(:user, {}).permit(
      :first_name,
      :last_name,
      :middle_name,
      :email,
      :username,
      :password,
      :role,
      :bio,
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ],
    )
  end

  def prepare_form
    @user.prepare_links

    @roles = current_user.assignable_role_options
  end

  def allowed_scopes
    super.merge({
      "Member" => :member,
      "Writer" => :writer,
      "Editor" => :editor,
      "Admin"  => :admin,
      "Root"   => :root
    })
  end

  def allowed_sorts
    super.merge({
      "Name"     => alpha_sort,
      "Username" => user_username_sort,
      "Email"    => user_email_sort,
      "Role"     => [user_role_sort, alpha_sort],
    })
  end
end
