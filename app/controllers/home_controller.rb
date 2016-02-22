class HomeController < ApplicationController
  def index
    @bootstrap_data = {}

    if user_session = Session.find_by(session_id: session.id)
      @bootstrap_data[:stars] = user_session.stars
      # TODO: don't hardcode this
      @bootstrap_data[:metro_area] = { id: user_session.metro_area_id, name: 'San Francisco, CA' }
      @bootstrap_data[:genres] = user_session.genres
    end
  end
end
