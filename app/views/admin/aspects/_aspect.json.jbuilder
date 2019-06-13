# frozen_string_literal: true

json.extract! aspect, :id, :human_key, :val, :created_at, :updated_at
json.url admin_aspect_url(aspect, format: :json)
