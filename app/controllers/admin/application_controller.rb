module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      authenticate_user!

      return true if user_signed_in? && current_user.admin?

      raise Pundit::NotAuthorizedError, I18n.t("admin.authentication.error")
    end

    def records_per_page
      params[:per_page] || 50
    end
  end
end
