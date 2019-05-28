# frozen_string_literal: true

json.array! @collection.resolved, partial: "admin/posts/#{controller_name}/post", as: :post
