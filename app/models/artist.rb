class Artist < ApplicationRecord
  self.primary_key = :musicbrainz_id

  def self.search_for_many(musicbrainz_ids)
    existing = where(musicbrainz_id: musicbrainz_ids).index_by(&:musicbrainz_id)

    (musicbrainz_ids - existing.keys).uniq.each do |id_to_search|
      spotify_id = ECHO_NEST.musicbrainz_to_spotify(id_to_search)

      existing[id_to_search] = create(musicbrainz_id: id_to_search, spotify_id: spotify_id).spotify_id
    end

    existing
  end

  def parsed_top_spotify_tracks
    if top_spotify_tracks.present?
      JSON.parse(top_spotify_tracks)
    else
      []
    end
  end

  def update_top_spotify_tracks
    return unless spotify_id
    return if top_spotify_tracks.present?

    update_attribute(:top_spotify_tracks, JSON.generate(SPOTIFY.get_top_tracks(spotify_id)))
  end
end
