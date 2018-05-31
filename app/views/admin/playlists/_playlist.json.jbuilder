json.extract! playlist, :id, :title, :created_at, :updated_at
json.url admin_playlist_url(playlist, format: :json)
