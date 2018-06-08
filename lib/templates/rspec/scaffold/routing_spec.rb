require "rails_helper"

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller, <%= type_metatag(:routing) %> do
<% unless options[:singleton] -%>
  it "#index" do
    expect(:get => "/<%= ns_table_name %>").to route_to("<%= ns_table_name %>#index")
  end

<% end -%>
<% unless options[:api] -%>
  it "#new" do
    expect(:get => "/<%= ns_table_name %>/new").to route_to("<%= ns_table_name %>#new")
  end
<% end -%>

  it "#show" do
    expect(:get => "/<%= ns_table_name %>/1").to route_to("<%= ns_table_name %>#show", :id => "1")
  end

<% unless options[:api] -%>
  it "#edit" do
    expect(:get => "/<%= ns_table_name %>/1/edit").to route_to("<%= ns_table_name %>#edit", :id => "1")
  end
<% end -%>

  it "#create" do
    expect(:post => "/<%= ns_table_name %>").to route_to("<%= ns_table_name %>#create")
  end

  it "#update via PUT" do
    expect(:put => "/<%= ns_table_name %>/1").to route_to("<%= ns_table_name %>#update", :id => "1")
  end

<% if Rails::VERSION::STRING > "4" -%>
  it "#update via PATCH" do
    expect(:patch => "/<%= ns_table_name %>/1").to route_to("<%= ns_table_name %>#update", :id => "1")
  end

<% end -%>
  it "#destroy" do
    expect(:delete => "/<%= ns_table_name %>/1").to route_to("<%= ns_table_name %>#destroy", :id => "1")
  end
end
<% end -%>
