# frozen_string_literal: true

class Admin::MixtapesController < Admin::PostsController

private

  def permitted_keys
    super.unshift(:playlist_id)
  end

  def prepare_form
    super

    @playlists = Playlist.for_admin.alpha
  end

  def allowed_sorts
    title_sort  = "posts.alpha ASC"
    status_sort = "posts.status ASC"
    author_sort = "users.username ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Status"  => [status_sort, title_sort].join(", "),
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
