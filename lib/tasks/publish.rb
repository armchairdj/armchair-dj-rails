# if memo.total == memo.success.length
#   logger.info "Published all #{memo[:total]} scheduled posts."
# else
#   logger.error "Could only publish #{memo[:success].length} of #{memo[:total]} scheduled posts. Failed posts: #{memo[:failure].map(&:id).join(', ')}"
# end
