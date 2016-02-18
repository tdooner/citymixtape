class LocationsController < ApplicationController
  def index
    res = LocationSearchResult.search_prefix(params[:location][:q])

    return render json: [] if res.none?

    render(json: res.map do |r|
      p = JSON.parse(r.results)
      next unless p.any?
      [p[0]['metro_area']['id'], r.query]
    end.compact.first(5))
  end

  def show
    query = params[:location][:query]
    @res = LocationSearchResult.create_from_query(query)
    render json: @res
  end

  def events
    location = params[:id].to_i

    if session.id
      Session.where(session_id: session.id)
        .first_or_initialize
        .update_attributes(metro_area_id: location)
    end

    performances = MetroAreaSearchResult.search(location)
    events = performances
      .flat_map { |p| p['performances'] }
      .map { |p| p['artist'] }
      .uniq { |a| a['id'] }
      .map { |a| a.slice('display_name', 'id') }
      .sort_by { |a| a['display_name'] }

    found_artists = Artist.where(songkick_id: events.map { |e| e['id'] }).where('spotify_id is not null').pluck(:songkick_id).to_set

    events.select! { |e| found_artists.include?(e['id']) }

    render json: {
      city: performances.first['location']['city'],
      events: events
    }

=begin
    performances_by_venue = performances.group_by { |p| p['venue'] }
    render(json: {
      city: performances.first['location']['city'],
      events: performances_by_venue.flat_map do |venue, performances|
        performances.map do |performance|
          artists = Array(performance['performances']).map { |p| p.fetch('artist', {}) }

          {
            id: performance['id'],
            artists: artists.map do |artist|
              # TODO: Handle multiple mbids
              mbid = artist.fetch('identifier', []).fetch(0, {})['mbid']
              found_on_spotify = mbid && Artist.find_by(musicbrainz_id: mbid).try(:spotify_id).present?

              {
                id: artist['id'],
                display_name: artist['display_name'],
                found_on_spotify: found_on_spotify
              }
            end,
            venue: { id: venue['id'], display_name: venue['display_name'] },
          }
        end
      end,
    })
=end
  end
end
