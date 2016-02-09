class LocationsController < ApplicationController
  def index
    res = LocationSearchResult.search_prefix(params[:location][:q])

    render(json: res.map do |r|
      [JSON.parse(r.results)[0]['metro_area']['id'], r.query]
    end)
  end

  def show
    query = params[:location][:query]
    @res = LocationSearchResult.create_from_query(query)
    render json: @res
  end

  def events
    location = params[:id].to_i
    performances = MetroAreaSearchResult.search(location)
    resp = {}
    resp['events'] = performances.each do |performance|
      mbid = performance.fetch('performances', []).first.fetch('artist', {}).fetch('identifier', [{}]).fetch(0, {})['mbid']
      performance['spotify_id'] = Artist.find_by(musicbrainz_id: mbid).try(:spotify_id) if mbid
    end
    resp['city'] = performances.first['location']['city']

    render(json: resp)
  end
end
