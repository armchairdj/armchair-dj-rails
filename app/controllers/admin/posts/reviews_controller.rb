# frozen_string_literal: true

class Admin::Posts::ReviewsController < Admin::Posts::BaseController

private

  def initial_keys
    [:work_id]
  end

  def prepare_form
    super

    @works = Work.grouped_by_medium
  end
end
