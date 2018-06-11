json.extract! mixtape, :id, :author_id, :tag_ids, :playlist_id, :body, :created_at, :updated_at
json.url permalink_url_for(mixtape, format: :json)
