# frozen_string_literal: true

module PolicyMethods

protected

  def can_administer?
    user.can_administer?
  end

  def owner_or_admin?
    (user.can_administer? || user == record.user)
  end

  def logged_in?
    return true if user

    raise Pundit::NotAuthenticatedError, "must be logged in"
  end

  def logged_in_as_admin?
    return true if user && can_administer?

    raise Pundit::NotAuthorizedError, "must be admin"
  end

  def raise_unauthorized
    return true if record_in_scope?

    raise Pundit::NotAuthorizedError, "unauthorized"
  end

  def record_in_scope?
    scope.where(id: record.id).exists?
  end
end