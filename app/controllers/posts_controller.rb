class PostsController < ApplicationController
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

  # GET /posts
  # GET /posts.json
  def index

  end

  # GET /posts/1
  # GET /posts/1.json
  def show

  end

  # GET /posts/new
  def new

  end

  # POST /posts
  # POST /posts.json
  def create
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: I18n.t("#{singular_table_name}.notice.create") }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /posts/1/edit
  def edit

  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(instance_params)
        format.html { redirect_to @post, notice: I18n.t("#{singular_table_name}.notice.update") }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: I18n.t("#{singular_table_name}.notice.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize class_name
  end

  def find_collection
    @posts = policy_scope(Post)
  end

  def build_new_instance
    @post = Post.new(instance_params)
  end

  def find_instance
    @post = Post.find(params[:id])
  end

  def authorize_instance
    authorize @post
  end

  def instance_params
    params.fetch(:post, {})
  end
end
