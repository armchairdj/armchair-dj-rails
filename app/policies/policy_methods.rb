# frozen_string_literal: true

module PolicyMethods

protected

  def admin?
    user.admin?
  end

  def owner_or_admin?
    (user.admin? || user == record.user)
  end

  def logged_in?
    return true if user

    raise Pundit::NotAuthenticatedError, "must be logged in"
  end

  def logged_in_as_admin?
    return true if user && admin?

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