# frozen_string_literal: true

class Admin::Posts::ArticlesController < Admin::Posts::BaseController

private

  def keys_for_create
    [:title]
  end
end
