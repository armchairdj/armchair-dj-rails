# frozen_string_literal: true

class PostPolicy < PublicPolicy
  def feed?
    index?
  end
end
