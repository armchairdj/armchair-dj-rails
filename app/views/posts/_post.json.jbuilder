case
when post.is_a?(Article)
  json.partial! "article/article", article: post
when post.is_a?(Review)
  json.partial! "review/review",   review: post
when post.is_a?(Mixtape)
  json.partial! "mixtape/mixtape", mixtape: post
end
