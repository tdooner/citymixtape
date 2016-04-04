class Artist < ApplicationRecord
  self.primary_key = :songkick_id

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
