class GenresController < ApplicationController
  def create
    return render :unprocessible_entity unless session.id

    genre = params[:genre]

    # TODO: Handle multiple genres
    Session.find_or_create_by(session_id: session.id).update_attribute(:genres, [genre])
  end

  def index
    q = params[:q].downcase.presence || ''

    results = []

    if q.present?
      results = GENRES.find_all { |g| g.start_with?(q) }.sort_by { |g| g.length }.first(10)
    end

    render json: {
      results: results
    }
  end
end
