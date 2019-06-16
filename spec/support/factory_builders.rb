# frozen_string_literal: true

# PROBLEM:
#   Sometimes we need to build an entire object hierarchy for specs, such
#   as a mixtape with a playlist with 15 tracks mapping to 15 works and
#   all of their related creator and intra-work relationships.
# SOLUTION:
#   Create some composite factories that build the entire relation.

module FactoryBuilders
  class Mixtape
    attr_reader :mixtape
    attr_reader :makers
    attr_reader :contributors
    attr_reader :playlist
    attr_reader :works

    with_options to: FactoryBot do
      delegate :create
      delegate :attributes_for
    end

    def initialize(status: :published, maker_names: [], contributor_names: [])
      @works = create_works(maker_names, contributor_names)
      @makers = collect_creators(:makers)
      @contributors = collect_creators(:contributors)
      @playlist = create_playlist
      @mixtape = create_mixtape(status)
    end

    private

    def create_works(maker_names, contributor_names)
      count = [2, maker_names.length, contributor_names.length].max

      count.times.each.with_object([]) do |(index), memo|
        makers = [maker_names[index]]
        contributors = [contributor_names[index]]

        memo << create(:minimal_song, :with_contributions, maker_names: makers, contributor_names: contributors)
      end
    end

    def collect_creators(method)
      @works.each.with_object({}) do |(work), memo|
        work.reload.send(method).each { |creator| memo[creator.name] = creator }
      end
    end

    def create_playlist
      tracks = @works.each.with_index.with_object({}) do |(work, index), memo|
        memo[index.to_s] = attributes_for(:playlist_track, work_id: work.id)
      end

      create(:minimal_playlist, tracks_attributes: tracks)
    end

    def create_mixtape(status)
      create(:minimal_mixtape, status.to_sym, playlist_id: @playlist.id)
    end
  end

  class KateBushAmongAngels < Mixtape
    private

    def create_works(*)
      @works = [
        create(:minimal_song, name: "Cloudbusting", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "Oh England My Lionheart", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "Mná Na Héireann", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "All the Love", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "And So Is Love", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "Snowed in at Wheeler Street", maker_names: ["Kate Bush", "Elton John"]),
        create(:minimal_song, name: "Houdini", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "Watching You Without Me", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "This Woman's Work", maker_names: ["Kate Bush"], subtitle: "Director's Cut"),
        create(:minimal_song, name: "Blow Away (For Bill)", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "A Coral Room", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "And Dream of Sheep", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "Among Angels", maker_names: ["Kate Bush"]),
        create(:minimal_song, name: "Moments of Pleasure", maker_names: ["Kate Bush"], subtitle: "Director's Cut"),
        create(:minimal_song, name: "Never Be Mine", maker_names: ["Kate Bush"], subtitle: "Director's Cut"),
        create(:minimal_song, name: "You're the One", maker_names: ["Kate Bush"])
      ]
    end
  end

  class PostModernCabaretMixtape1 < Mixtape
    private

    def create_works(*)
      @works = [
        create(:minimal_song, name: "Can You Hear Me", maker_names: ["Missy Elliott", "TLC"]),
        create(:minimal_song, name: "A Perfect Match", maker_names: ["Tech & The Effx"]),
        create(:minimal_song, name: "Mjisnjedschaz", maker_names: ["Barbara Morgenstern"]),
        create(:minimal_song, name: "Walking in the Rain", maker_names: ["Grace Jones"]),
        create(:minimal_song, name: "I See", maker_names: ["MJ Cole"]),
        create(:minimal_song, name: "Who Knew?!", maker_names: ["Sandra Bernhard"]),
        create(:minimal_song, name: "Déjà Vu", maker_names: ["Dionne Warwick"], subtitle: "Single Edit"),
        create(:minimal_song, name: "Champagne, Cocaine and Nicotine Stains", maker_names: ["Lydia Lunch", "The Anubian Lights"]),
        create(:minimal_song, name: "Breakout", maker_names: ["Swing Out Sister"]),
        create(:minimal_song, name: "Nice Mover", maker_names: ["Gina X Performance"]),
        create(:minimal_song, name: "Eau d'Bedroom Dancing", maker_names: ["Le Tigre"]),
        create(:minimal_song, name: "Caught a Lite Sneeze", maker_names: ["Tori Amos"]),
        create(:minimal_song, name: "Venus des Abribus", maker_names: ["Patricia Kaas"]),
        create(:minimal_song, name: "Sci-Fi Wasabi", maker_names: ["Cibo Matto"]),
        create(:minimal_song, name: "Four Women", maker_names: ["Nina Simone"]),
        create(:minimal_song, name: "Ask the Dragon", maker_names: ["Yoko Ono", "IMA"], contributor_names: ["Ween"], subtitle: "Ween Remix"),
        create(:minimal_song, name: "Empires", maker_names: ["Lamya"]),
        create(:minimal_song, name: "The Morning Fog", maker_names: ["Kate Bush"])
      ]
    end
  end
end
