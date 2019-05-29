# frozen_string_literal: true

class PlaylistScoper < Ginsu::Scoper
private

  def model_class
    Playlist
  end
end
