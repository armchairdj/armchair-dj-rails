class PostPolicy < PublicPolicy
  class Scope < Scope
    def resolve
      scope.for_site.reverse_cron
    end
  end
end
