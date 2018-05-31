json.extract! medium, :id, :name, :created_at, :updated_at
json.url permalink_url_for(medium, format: :json)
