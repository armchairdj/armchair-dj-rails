json.extract! post, :id, :title, :work_id, :body, :created_at, :updated_at
json.url admin_post_url(post, format: :json)
