class PagePolicy < Struct.new(:user, :page)
  include PolicyMethods

  def show?
    true
  end
end
