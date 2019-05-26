# frozen_string_literal: true

case
when post.is_a?(Article)
  json.partial! "posts/articles/article", article: post
when post.is_a?(Review)
  json.partial! "posts/reviews/review",   review:  post
when post.is_a?(Mixtape)
  json.partial! "posts/mixtapes/mixtape", mixtape: post
end
