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
    render json: MetroAreaSearchResult.search(location)
  end
end
