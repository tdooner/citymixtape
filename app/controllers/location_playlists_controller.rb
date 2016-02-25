class LocationPlaylistsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    location = params[:id]

    picker = PlaylistSongPicker.new(location)

    if session.id && (user_session = Session.find_by(session_id: session.id))
      picker.personalize_stars(user_session.stars)
      picker.personalize_genres(user_session.genres)
    end

    playlist_uri = SPOTIFY.create_playlist(picker.songs)
    human_uri = SPOTIFY.get_playlist_by_uri(playlist_uri)['external_urls']['spotify']

    render json: {
      spotify_uri: human_uri
    }
  end
end
