class StyleGuidePolicy < Struct.new(:user, :page)
  def show?
    true
  end
end
