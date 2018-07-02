# frozen_string_literal: true

class Admin::ReviewsController < Admin::PostsController

private

  def permitted_keys
    super.unshift(:work_id)
  end

  def prepare_form
    super

    @works = Work.grouped_options
  end

  def allowed_sorts
    super.merge({ "Medium" => [work_medium_sort, alpha_sort] })
  end
end
