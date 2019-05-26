# frozen_string_literal: true

json.extract! review, :id, :author_id, :tag_ids, :work_id, :body, :created_at, :updated_at
json.url url_for_post(review, format: :json)
