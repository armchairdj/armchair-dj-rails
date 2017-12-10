<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

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
  def index
    @<%= plural_table_name %> = policy_scope(<%= class_name %>)
  end

  # GET <%= route_url %>/1
  def show

  end

  # GET <%= route_url %>/new
  def new

  end

  # POST <%= route_url %>
  def create
    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: I18n.t("#{singular_table_name}.notice.create")
    else
      render :new
    end
  end

  # GET <%= route_url %>/1/edit
  def edit

  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("instance_params") %>
      redirect_to @<%= singular_table_name %>, notice: I18n.t("#{singular_table_name}.notice.update")
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>

    redirect_to <%= index_helper %>_url, notice: I18n.t("#{singular_table_name}.notice.destroy")
  end

private

  def authorize_collection
    authorize class_name
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
    params.fetch(:<%= singular_table_name %>, {}).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
  end
end
<% end -%>
