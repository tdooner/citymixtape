class LocationPlaylistsController < ApplicationController
  def create
    user_session = Session.find_by(session_id: session.id)
    return render :unprocessible_entity unless user_session

    location = params[:id]

    picker = PlaylistSongPicker.new(location)
    picker.personalize_stars(user_session.stars)
    picker.personalize_genres(user_session.genres)

    playlist_name = [
      params[:first_name],
      MetroAreaSearchResult.find_by(metro_area_id: location).city_name,
    ].join(' – ')

    playlist_uri = SPOTIFY.create_playlist(picker.songs, name: playlist_name)
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
