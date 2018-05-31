json.extract! playlist, :id, :title, :created_at, :updated_at
json.url permalink_url_for(playlist, format: :json)
