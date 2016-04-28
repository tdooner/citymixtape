class Artist < ApplicationRecord
  self.primary_key = :songkick_id

  scope :by_genre, ->(genre) { where("genres ? #{connection.quote(genre)}") }

  scope :playing_in, ->(metro_area_id) {
    where("musicbrainz_id IN (
SELECT DISTINCT(identifiers->>'mbid')
AS playing_soon_mbid
FROM metro_area_search_results m,
     jsonb_array_elements(m.results::jsonb) shows,
     jsonb_array_elements(shows->'performances') performances,
     jsonb_array_elements(performances->'artist'->'identifier') identifiers
WHERE m.metro_area_id = #{sanitize(metro_area_id)})");
  }

  def self.similar_to(songkick_id)
    where('similar_artists @> ?', songkick_id.to_s)
  end

  def sync!
    return if updated_at > 1.week.ago

    update_top_spotify_tracks if spotify_id.present?

    similar = SONGKICK.similar_artists(songkick_id).results.map(&:id)
    update_attributes(similar_artists: similar) if similar.any?

    artist = ECHO_NEST.fetch_artist_profile(musicbrainz_id)

    if artist
      update_attributes(
        spotify_id: artist['spotify_id'],
        genres: artist['genres'],
      )
    end

    touch
  end

  def parsed_top_spotify_tracks
    if top_spotify_tracks.present?
      JSON.parse(top_spotify_tracks) rescue []
    else
      []
    end
  end

  def update_top_spotify_tracks
    return unless spotify_id.present?
    return if top_spotify_tracks.present?

    update_attribute(:top_spotify_tracks, JSON.generate(SPOTIFY.get_top_tracks(spotify_id)))
  end
end
