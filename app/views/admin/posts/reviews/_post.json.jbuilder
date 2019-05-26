# frozen_string_literal: true

json.extract! post, :id, :author_id, :tag_ids, :work_id, :body, :created_at, :updated_at
json.url url_for_post(post, admin: true, full_url: true, format: :json)
