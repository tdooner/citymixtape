class LocationsController < ApplicationController
  def index
  end

  def show
    query = params[:location][:query]
    @res = LocationSearchResult.create_from_query(query)
    render json: @res
  end

  def events
    location = params[:id].to_i
    res = MetroAreaSearchResult.search(location)
    render(json: res.each do |performance|
      mbid = performance.fetch('performances', []).first.fetch('artist', {}).fetch('identifier', [{}]).fetch(0, {})['mbid']
      performance['spotify_id'] = Artist.find_by(musicbrainz_id: mbid).try(:spotify_id) if mbid
    end)
  end
end
