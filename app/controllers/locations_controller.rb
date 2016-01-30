class LocationsController < ApplicationController
  def index
  end

  def show
    query = params[:location][:query]
    @res = LocationSearchResult.create_from_query(query)
  end
end
