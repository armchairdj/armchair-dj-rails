# frozen_string_literal: true

# == Schema Information
#
# Table name: aspects
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  key        :integer          not null
#  val        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_aspects_on_alpha  (alpha)
#  index_aspects_on_key    (key)
#

class Aspect < ApplicationRecord
  # This must go before the #PostsAssociation block.
  concerning :WorksAssociation do
    included do
      has_and_belongs_to_many :works, -> { distinct }

      has_many :playlists,    -> { distinct }, through: :works
      has_many :makers,       -> { distinct }, through: :works
      has_many :contributors, -> { distinct }, through: :works
    end
  end

  concerning :Alphabetization do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [human_key, val]
    end
  end

  concerning :GinsuIntegration do
    included do
      scope :for_list, -> {}
      scope :for_show, -> { includes(:works, :makers, :contributors, :playlists, :mixtapes, :reviews) }
    end
  end

  concerning :KeyAttribute do
    included do
      validates :key, presence: true

      enum key: {
        album_format:      0,
        song_type:         1,
        music_label:       2,
        musical_genre:     3,
        musical_mood:      4,

        audio_show_format: 100,
        radio_network:     101,
        podcast_network:   102,

        narrative_genre:   200,
        hollywood_studio:  201,
        tv_network:        202,

        publisher:         301,
        publication_type:  302,

        tech_platform:     401,
        tech_company:      402,
        device_type:       403,

        product_type:      501,
        manufacturer:      502,

        game_mechanic:     601,
        game_studio:       602
      }

      improve_enum :key

      scope :for_key, ->(*keys) { where(key: keys.flatten.compact) }
    end
  end

  concerning :ValAttribute do
    included do
      validates :val, presence: true
      validates :val, uniqueness: { scope: [:key] }
    end

    def display_val(connector: ": ")
      [human_key, val].compact.join(connector)
    end
  end

  concerning :PostsAssociation do
    included do
      has_many :mixtapes, through: :works
      has_many :reviews,  through: :works
    end

    def posts
      Post.where(id: post_ids)
    end

    def post_ids
      reviews.ids + mixtapes.ids
    end
  end
end
