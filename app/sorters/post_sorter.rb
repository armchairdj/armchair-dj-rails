# frozen_string_literal: true

class PostSorter < Sorter
  def allowed
    super.merge({
      "Title"   => alpha_sort_sql,
      "Status"  => [post_status_sort_sql, alpha_sort_sql],
      "Author"  => [author_sort_sql,      alpha_sort_sql],
    })
  end

private

  def model_class
    Post
  end

  def post_status_sort_sql
    "posts.status ASC"
  end
end
