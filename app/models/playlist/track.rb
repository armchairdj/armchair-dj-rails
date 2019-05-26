# frozen_string_literal: true

# == Schema Information
#
# Table name: playlist_tracks
#
#  id          :bigint(8)        not null, primary key
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :bigint(8)
#  work_id     :bigint(8)
#
# Indexes
#
#  index_playlist_tracks_on_playlist_id  (playlist_id)
#  index_playlist_tracks_on_work_id      (work_id)
#

class Playlist::Track < ApplicationRecord
  self.table_name = "playlist_tracks"

  #############################################################################
  # CONCERNING: Playlist.
  #############################################################################

  include Listable

  concerning :PlaylistAssociation do
    included do
      belongs_to :playlist, inverse_of: :tracks

      validates :playlist, presence: true

      acts_as_listable(:playlist)
    end
  end

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  concerning :WorkAssociation do
    included do
      belongs_to :work, inverse_of: :playlistings

      validates :work, presence: true
    end
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list, -> { sorted }
  scope :for_show, -> { sorted.includes(:playlist, :work) }
end
