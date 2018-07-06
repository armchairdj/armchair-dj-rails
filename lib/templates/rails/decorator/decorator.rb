# frozen_string_literal: true

<%- module_namespacing do -%>
  <%- if parent_class_name.present? -%>
class <%= class_name %>Decorator < <%= parent_class_name %>Decorator
  <%- else -%>
class <%= class_name %>Decorator < ApplicationDecorator
  <%- end -%>

end
<% end -%>
