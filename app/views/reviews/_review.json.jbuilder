json.extract! review, :id, :author_id, :tag_ids, :work_id, :body, :created_at, :updated_at
json.url permalink_url_for(review, format: :json)
