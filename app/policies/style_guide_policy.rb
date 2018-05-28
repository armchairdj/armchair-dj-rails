# frozen_string_literal: true

class StyleGuidePolicy < Struct.new(:user, :page)
  include PolicyMethods

  def index?
    logged_in_as_cms_user?
  end

  def show?
    logged_in_as_cms_user?
  end

  def flash_message?
    logged_in_as_cms_user?
  end

  def error_page?
    logged_in_as_cms_user?
  end
end
