json.extract! article, :id, :title, :work_id, :body, :created_at, :updated_at
json.url admin_article_url(article, format: :json)
