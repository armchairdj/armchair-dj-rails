# frozen_string_literal: true

json.extract! article, :id, :author_id, :tag_ids, :title, :body, :created_at, :updated_at
json.url url_for_post(article, format: :json)
