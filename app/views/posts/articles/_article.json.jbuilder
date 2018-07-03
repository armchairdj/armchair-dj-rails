json.extract! article, :id, :author_id, :tag_ids, :title, :body, :created_at, :updated_at
json.url permalink_for(article, format: :json)
