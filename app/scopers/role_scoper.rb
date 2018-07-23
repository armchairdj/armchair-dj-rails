# frozen_string_literal: true

class RoleScoper < Ginsu::Scoper

private

  def model_class
    Role
  end
end
