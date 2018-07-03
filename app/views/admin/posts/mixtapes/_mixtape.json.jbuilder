json.extract! mixtape, :id, :author_id, :tag_ids, :playlist_id, :body, :created_at, :updated_at
json.url admin_mixtape_url(mixtape, format: :json)
