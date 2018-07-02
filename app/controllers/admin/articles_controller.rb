# frozen_string_literal: true

class Admin::ArticlesController < Admin::PostsController

private

  def permitted_keys
    super.unshift(:title)
  end
end
