json.extract! work, :id, :name, :medium, :categories, :tags, :created_at, :updated_at
json.url permalink_url_for(work, format: :json)
