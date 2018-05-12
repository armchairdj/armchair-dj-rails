# frozen_string_literal: true

json.extract! user, :id, :first_name, :middle_name, :last_name, :role, :created_at, :updated_at
json.url admin_user_url(user, format: :json)
