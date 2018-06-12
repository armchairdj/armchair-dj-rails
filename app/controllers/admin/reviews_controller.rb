# frozen_string_literal: true

class Admin::ReviewsController < Admin::PostsController

private

  def update_params
    params.fetch(:review, {}).permit(
      :work_id,
      :body,
      :summary,
      :publish_on,
      :tag_ids => [],
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ]
    )
  end

  def prepare_form
    super

    @works = Work.grouped_options
  end

  def allowed_sorts
    title_sort  = "posts.alpha ASC"
    status_sort = "posts.status ASC"
    author_sort = "users.alpha ASC"
    type_sort   = "LOWER(works.type) ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Type"    => [type_sort,   title_sort].join(", "),
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
