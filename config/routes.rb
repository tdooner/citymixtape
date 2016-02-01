Rails.application.routes.draw do
  namespace 'api' do
    post '/locations', to: '/locations#show'
    get '/locations/:id/events', to: '/locations#events'
  end

  root to: 'home#index'
  # mount ActionCable.server => '/cable'
end
