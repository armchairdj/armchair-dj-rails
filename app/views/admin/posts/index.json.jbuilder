# frozen_string_literal: true

json.array! @posts, partial: "admin/posts/post", as: :post
