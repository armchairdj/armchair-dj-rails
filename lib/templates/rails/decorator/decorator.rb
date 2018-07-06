# frozen_string_literal: true

<%- module_namespacing do -%>
  <%- if parent_class_name == "Draper::Decorator" -%>
class <%= class_name %>Decorator < InstanceDecorator
  <%- else -%>
class <%= class_name %>Decorator < <%= parent_class_name %>Decorator
  <%- end -%>

end
<% end -%>
