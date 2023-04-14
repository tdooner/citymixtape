class StarsController < ApplicationController
  before_action :validate_type
  before_action :validate_session

  def create
    star = Session.star!(session.id, params[:type], params[:id])
    render json: star.stars
  end

  def destroy
    star = Session.unstar!(session.id, params[:type], params[:id])
    render json: star.stars
  end

private

  def validate_session
    unless session.id.present?
      render text: 'no cookies; cannot save!', status: :forbidden
    end
  end

  def validate_type
    unless %w[artist venue].include?(params[:type])
      render text: 'invalid type!', status: :unprocessable_entity
    end
  end
end
