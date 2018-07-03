case
when post.is_a?(Article)
  json.partial! "posts/article/article", article: post
when post.is_a?(Review)
  json.partial! "posts/review/review",   review:  post
when post.is_a?(Mixtape)
  json.partial! "posts/mixtape/mixtape", mixtape: post
end
