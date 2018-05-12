# frozen_string_literal: true

json.extract! work, :id, :name, :medium, :categories, :tags, :created_at, :updated_at
json.url work_url(work, format: :json)
