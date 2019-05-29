# frozen_string_literal: true

if post.is_a?(Article)
  json.partial! "posts/articles/article", article: post
elsif post.is_a?(Review)
  json.partial! "posts/reviews/review",   review:  post
elsif post.is_a?(Mixtape)
  json.partial! "posts/mixtapes/mixtape", mixtape: post
end
