# frozen_string_literal: true

def log_it(str, error: false)
  puts str

  Rails.logger.public_send(error ? :error : :info, str)
end

namespace :publish do
  desc "Publish scheduled posts once per day."
  task scheduled: :environment do
    log_it I18n.t("rake.publish.scheduled.ready")

    memo = Post.publish_scheduled

    total         = memo[:all    ].length
    success       = memo[:success].length
    success_slugs = memo[:success].map{ |x| "  * #{x.slug}" }.join("\n")
    failure_slugs = memo[:failure].map{ |x| "  * #{x.slug}" }.join("\n")

    message = if total.zero?
      I18n.t("rake.publish.scheduled.none")
    elsif total == success
      I18n.t("rake.publish.scheduled.success", total: total, success_slugs: success_slugs)
    else
      I18n.t("rake.publish.scheduled.failure", total: total, success_slugs: success_slugs, success: success, failure_slugs: failure_slugs)
    end

    log_it message, error: (total != success)
  end
end

desc "Publish scheduled posts once per day."
task publish: "publish:scheduled"
