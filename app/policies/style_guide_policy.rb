class StyleGuidePolicy < Struct.new(:user, :page)
  include PolicyMethods

  def index?
    logged_in_as_admin?
  end

  def show?
    logged_in_as_admin?
  end

  def flash_message?
    logged_in_as_admin?
  end

  def error_page?
    logged_in_as_admin?
  end
end
