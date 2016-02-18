class SessionsController < ApplicationController
  def show
    session.options[:id] = params[:id]
    redirect_to root_path
  end
end
