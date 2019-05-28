# frozen_string_literal: true

module Admin
  module Posts
    class MixtapesController < Admin::Posts::BaseController
      private

      def keys_for_create
        [:playlist_id]
      end

      def prepare_form
        super

        @playlists = Playlist.alpha
      end
    end
  end
end
