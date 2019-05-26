# frozen_string_literal: true

module PolicyMethods
protected

  def logged_in?
    return true if user

    raise Pundit::NotAuthenticatedError, "must be logged in"
  end

  def logged_in_as_cms_user?
    return true if user && user.can_write?

    raise Pundit::NotAuthorizedError, "current user does not have permission"
  end

  def logged_in_as_admin_or_root?
    return true if user && user.can_administer?

    raise Pundit::NotAuthorizedError, "current user does not have permission"
  end

  def logged_in_as_root?
    return true if user && user.root?

    raise Pundit::NotAuthorizedError, "current user does not have permission"
  end

  def raise_unauthorized
    return true if record_in_scope?

    raise Pundit::NotAuthorizedError, "unauthorized"
  end

  def record_in_scope?
    scope.where(id: record.id).exists?
  end
end