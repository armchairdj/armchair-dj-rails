json.extract! article, :id, :author_id, :tag_ids, :title, :body, :created_at, :updated_at
json.url admin_article_url(article, format: :json)
