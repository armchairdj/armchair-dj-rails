class PostPolicy < CrudPolicy
  class Scope < Scope
    def resolve
      scope.all.reverse_cron
    end
  end
end
