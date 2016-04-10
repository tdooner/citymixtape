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
    return render :unprocessible_entity unless session.id

    location = params[:id].to_i

    current_session = Session.find_or_create_by(session_id: session.id)
    current_session.update_attributes(metro_area_id: location) unless location == 0

    performances = MetroAreaSearchResult.search(location)
    performances.each do |performance|
      performance['performances'].each do |p|
        p['artist']['songkick_ticket_url'] = performance['uri']
      end
    end

    events = performances
      .flat_map { |p| p['performances'] }
      .map { |p| p['artist'] }
      .uniq { |a| a['id'] }
      .map { |a| a.slice('display_name', 'id', 'songkick_ticket_url') }
      .sort_by { |a| a['display_name'] }

    # TODO: Handle multiple genres
    found_artists = Artist
      .where('spotify_id is not null')
      .where("songkick_id IN (#{events.map { |e| e['id'] }.join(',')})")
      .where('genres ?| array[:genres]',
             genres: (GenreSimilarity.similar_to(current_session.genres.first).presence || current_session.genres.first.inspect))
      .pluck(:songkick_id)
      .to_set

    events.select! { |e| found_artists.include?(e['id']) }

    render json: {
      city: MetroAreaSearchResult.find_by(metro_area_id: location).city_name,
      events: events
    }
  end
end
