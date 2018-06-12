# frozen_string_literal: true

class Admin::ArticlesController < Admin::PostsController

private

  def update_params
    params.fetch(:article, {}).permit(
      :title,
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

  def allowed_sorts
    title_sort  = "posts.alpha ASC"
    status_sort = "posts.status ASC"
    author_sort = "users.alpha ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
