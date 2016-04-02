Rails.application.routes.draw do
  namespace 'api' do
    get '/locations', to: '/locations#index'
    post '/locations', to: '/locations#show'
    get '/locations/:id/events', to: '/locations#events'
    post '/locations/:id/playlist', to: '/location_playlists#create'
    get '/genres', to: '/genres#index'
    post '/genres', to: '/genres#create'

    post '/stars/:type/:id', to: '/stars#create'
    delete '/stars/:type/:id', to: '/stars#destroy'
  end

  resources :sessions, only: %i[show]

  %w[genres events playlist].each do |js_page|
    get js_page, to: 'home#index'
  end
  root to: 'home#index'
  # mount ActionCable.server => '/cable'
end
