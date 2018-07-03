# frozen_string_literal: true

class Admin::Posts::ArticlesController < Admin::Posts::BaseController

private

  def permitted_keys
    super.unshift(:title)
  end
end
