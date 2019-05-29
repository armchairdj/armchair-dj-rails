# frozen_string_literal: true

json.array! @roles, partial: "admin/roles/role", as: :role
