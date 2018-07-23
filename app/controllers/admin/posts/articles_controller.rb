# frozen_string_literal: true

class Admin::Posts::ArticlesController < Admin::Posts::BaseController

private

  def initial_keys
    [:title]
  end
end
