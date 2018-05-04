<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
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

  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index

  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show

  end

  # GET <%= route_url %>/new
  def new

  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, success: I18n.t("<%= singular_table_name %>.success.create") }
        format.json { render :show, status: :created, location: <%= "@#{singular_table_name}" %> }
      else
        format.html { render :new }
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  # GET <%= route_url %>/1/edit
  def edit

  end

  # PATCH/PUT <%= route_url %>/1
  # PATCH/PUT <%= route_url %>/1.json
  def update
    respond_to do |format|
      if @<%= orm_instance.update("instance_params") %>
        format.html { redirect_to @<%= singular_table_name %>, success: I18n.t("<%= singular_table_name %>.success.update") }
        format.json { render :show, status: :ok, location: <%= "@#{singular_table_name}" %> }
      else
        format.html { render :edit }
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url, success: I18n.t("<%= singular_table_name %>.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize @<%= plural_table_name %>
  end

  def find_collection
    @<%= plural_table_name %> = policy_scope(<%= class_name %>)
  end

  def build_new_instance
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "instance_params") %>
  end

  def find_instance
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def authorize_instance
    authorize @<%= singular_table_name %>
  end

  def instance_params
    <%- if attributes_names.empty? -%>
    params.fetch(:<%= singular_table_name %>, {})
    <%- else -%>
    params.fetch(:<%= singular_table_name %>, {}).permit(<%= attributes_names.map { |name| ":#{name}" }.join(", ") %>)
    <%- end -%>
  end
end
<% end -%>
