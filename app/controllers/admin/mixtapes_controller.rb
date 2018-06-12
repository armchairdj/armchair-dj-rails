# frozen_string_literal: true

class Admin::MixtapesController < Admin::PostsController

private

  def update_params
    params.fetch(:mixtape, {}).permit(
      :playlist_id,
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

    @playlists = Playlist.for_admin.alpha
  end
end
