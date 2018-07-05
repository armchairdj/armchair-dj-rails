# frozen_string_literal: true

class Admin::Posts::ReviewsController < Admin::Posts::BaseController

private

  def permitted_keys
    super.unshift(:work_id)
  end

  def prepare_form
    super

    @works = Work.grouped_by_medium
  end

  def allowed_sorts
    super.merge({ "Medium" => [work_medium_sort, alpha_sort] })
  end
end
