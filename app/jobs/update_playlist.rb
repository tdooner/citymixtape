class UpdatePlaylist < ApplicationJob
  def perform(location, stars, genres, playlist_uri)
    picker = PlaylistSongPicker.new(location)
    picker.personalize_stars(stars)
    picker.personalize_genres(genres)

    playlist = SPOTIFY.get_playlist_by_uri(URI(playlist_uri))
    SPOTIFY.replace_playlist_tracks(playlist['href'], picker.songs)
  end
end
