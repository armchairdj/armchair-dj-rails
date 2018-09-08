json.extract! post, :id, :author_id, :tag_ids, :playlist_id, :body, :created_at, :updated_at
json.url url_for_post(post, admin: true, full_url: true, format: :json)
