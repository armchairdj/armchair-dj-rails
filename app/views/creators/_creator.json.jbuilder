json.extract! creator, :id, :name, :created_at, :updated_at
json.url permalink_url_for(creator, format: :json)
