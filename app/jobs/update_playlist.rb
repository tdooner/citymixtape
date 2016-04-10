class UpdatePlaylist < ApplicationJob
  def perform(session)
    picker = PlaylistSongPicker.new(session.location)
    picker.personalize_stars(session.stars)
    picker.personalize_genres(session.genres)

    if session.playlist_uri
      playlist = SPOTIFY.get_playlist_by_uri(URI(session.playlist_uri))
      SPOTIFY.replace_playlist_tracks(playlist['href'], picker.songs)
    else
      playlist_uri = SPOTIFY.create_playlist(picker.songs)
      session.update_attributes(
        playlist_uri: playlist_uri,
        playlist_songs: picker.songs,
      )
    end
  end
end
