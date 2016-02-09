Rails.application.routes.draw do
  namespace 'api' do
    get '/locations', to: '/locations#index'
    post '/locations', to: '/locations#show'
    get '/locations/:id/events', to: '/locations#events'
    post '/locations/:id/playlist', to: '/location_playlists#create'
  end

  root to: 'home#index'
  # mount ActionCable.server => '/cable'
end
