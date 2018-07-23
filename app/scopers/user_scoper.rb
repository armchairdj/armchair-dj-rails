# frozen_string_literal: true

class UserScoper < Scoper
  def allowed
    super.merge({
      "Member" => :member,
      "Writer" => :writer,
      "Editor" => :editor,
      "Admin"  => :admin,
      "Root"   => :root
    })
  end

private

  def model_class
    User
  end
end
