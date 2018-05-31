class PlaylistsController < PublicController

private

  def find_collection
    @playlists = scoped_collection
  end

  def find_instance
    @playlist = scoped_instance_by_slug
  end
end
