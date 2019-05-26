# frozen_string_literal: true

json.extract! creator, :id, :name, :created_at, :updated_at
json.url admin_creator_url(creator, format: :json)
