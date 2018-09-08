json.extract! post, :id, :author_id, :tag_ids, :title, :body, :created_at, :updated_at
json.url url_for_post(post, admin: true, full: true, format: :json)
