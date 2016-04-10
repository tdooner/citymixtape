class HomeController < ApplicationController
  def index
    @bootstrap_data = {}

    if user_session = Session.find_by(session_id: session.id)
      @bootstrap_data[:stars] = user_session.stars
      # TODO: don't hardcode this
      @bootstrap_data[:metro_area] = { id: user_session.metro_area_id, name: 'San Francisco, CA' }
      @bootstrap_data[:genres] = user_session.genres
      @bootstrap_data[:playlist] = {
        url: SpotifyClient.convert_playlist_url(user_session.playlist_uri)
      }
    end
  end
end
