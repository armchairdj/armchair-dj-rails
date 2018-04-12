class Admin::PostPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      scope.for_admin.reverse_cron
    end
  end
end
