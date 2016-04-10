class LocationPlaylistsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user_session = Session.find_by(session_id: session.id)
    return render :unprocessible_entity unless user_session

    location = params[:id]

    picker = PlaylistSongPicker.new(location)
    picker.personalize_stars(user_session.stars)
    picker.personalize_genres(user_session.genres)

    playlist_uri = SPOTIFY.create_playlist(picker.songs)
    human_uri = SPOTIFY.get_playlist_by_uri(playlist_uri)['external_urls']['spotify']

    user_session.update_attributes(
      playlist_songs: picker.songs,
      playlist_uri: playlist_uri,
      name: params[:first_name],
      email: params[:email],
      newsletter_opt_in: params[:email] == 'true',
    )

    render json: {
      spotify_uri: human_uri
    }
  end
end
