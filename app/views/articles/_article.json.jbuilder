json.extract! article, :id, :title, :work_id, :body, :created_at, :updated_at
json.url permalink_url_for(article, format: :json)
