Rails.application.routes.draw do
  get '/locations', to: 'locations#index' 
  post '/locations', to: 'locations#show'

  root to: 'locations#index'
  # mount ActionCable.server => '/cable'
end
