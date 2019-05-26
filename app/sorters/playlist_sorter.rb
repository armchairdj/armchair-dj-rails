# frozen_string_literal: true

class PlaylistSorter < Ginsu::Sorter
  def allowed
    super.merge(
      "Title"   => alpha_sort_sql,
      "Author"  => [author_sort_sql, alpha_sort_sql],
    )
  end

private

  def model_class
    Playlist
  end
end
