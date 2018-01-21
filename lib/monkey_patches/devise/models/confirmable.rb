# Monkey-patching Devise methods to customize our authentication scheme.
# All we've done is break some logic out of #confirm and put it in
# #force_confirmation so we can call that from active_admin.

module Devise
  module Models
    module Confirmable
      def confirm(args={})
        pending_any_confirmation do
          if confirmation_period_expired?
            self.errors.add(:email, :confirmation_period_expired, period: Devise::TimeInflector.time_ago_in_words(self.class.confirm_within.ago))

            return false
          end

          self.force_confirmation(args)
        end
      end

      def force_confirmation(args={})
        pending_any_confirmation do
          self.confirmed_at = Time.now.utc

          saved = if pending_reconfirmation?
            skip_reconfirmation!

            self.email             = unconfirmed_email
            self.unconfirmed_email = nil

            # We need to validate in such cases to enforce e-mail uniqueness
            save(validate: true)
          else
            save(validate: args[:ensure_valid] == true)
          end

          after_confirmation if saved

          saved
        end
      end
    end
  end
end
