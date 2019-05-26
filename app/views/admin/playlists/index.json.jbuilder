# frozen_string_literal: true

json.array! @playlists, partial: "admin/playlists/playlist", as: :playlist
