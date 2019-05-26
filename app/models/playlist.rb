# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#
# Indexes
#
#  index_playlists_on_alpha  (alpha)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#

class Playlist < ApplicationRecord

  #############################################################################
  # CONCERNING: Image attachment.
  #############################################################################

  include Imageable

  #############################################################################
  # CONCERNING: Authorable.
  #############################################################################

  include Authorable

  #############################################################################
  # CONCERNING: Title.
  #############################################################################

  concerning :TitleAttribute do
    included do
      validates :title, presence: true
    end
  end

  #############################################################################
  # CONCERNING: Tracks.
  #############################################################################

  concerning :TrackAssociations do
    included do
      has_many :tracks, -> { order(:position) }, inverse_of: :playlist,
        class_name: "Playlist::Track", dependent: :destroy

      validates :tracks, length: { minimum: 2 }

      has_many :works, through: :tracks

      accepts_nested_attributes_for(:tracks, allow_destroy: true,
        reject_if: proc { |attrs| attrs["work_id"].blank? }
      )
    end

    def prepare_tracks
      20.times { self.tracks.build }
    end
  end

  #############################################################################
  # CONCERNING: Works.
  #############################################################################

  concerning :CreatorAssociations do
    included do
      has_many :makers,       -> { distinct }, through: :works
      has_many :contributors, -> { distinct }, through: :works
    end

    def creators
      Creator.where(id: creator_ids)
    end

    def creator_ids
      works.map(&:creator_ids).flatten.uniq
    end
  end

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  concerning :PostAssociations do
    included do
      has_many :mixtapes, dependent: :nullify

      has_many :reviews, through: :works
    end

    def posts
      Post.where(id: post_ids)
    end

    def post_ids
      reviews.ids + mixtapes.ids
    end
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> { includes(:author).references(:author) }
  scope :for_show,  -> { includes(:author, :tracks, :works) }

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  concerning :Alphabetization do
    def alpha_parts
      [title]
    end
  end
end
