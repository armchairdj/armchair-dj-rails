class PagePolicy < Struct.new(:user, :page)
  def show?
    true
  end
end
