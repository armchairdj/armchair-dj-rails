json.extract! review, :id, :author_id, :tag_ids, :work_id, :body, :created_at, :updated_at
json.url admin_review_url(review, format: :json)
