class LocationPlaylistsController < ApplicationController
  def create
    location = params[:id]

    res = MetroAreaSearchResult.search(location)
    playlist_songs = []
    res.each do |performance|
      mbid = performance
        .fetch('performances', [])
        .first
        .fetch('artist', {})
        .fetch('identifier', [{}])
        .fetch(0, {})['mbid']
      next unless mbid

      artist = Artist.find_by(musicbrainz_id: mbid)
      next unless artist
      next unless artist.parsed_top_spotify_tracks.any?

      playlist_songs << artist.parsed_top_spotify_tracks.first
    end

    playlist_uri = SPOTIFY.create_playlist(playlist_songs.map { |_name, id| id })
    human_uri = SPOTIFY.get_playlist_by_uri(playlist_uri)['external_urls']['spotify']

    render json: {
      spotify_uri: human_uri
    }
  end
end
