class PagePolicy < Struct.new(:user, :page)
  def index?
    true
  end
end
