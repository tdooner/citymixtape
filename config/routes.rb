Rails.application.routes.draw do
  namespace 'api' do
    post '/locations', to: 'locations#show'
  end

  root to: 'home#index'
  # mount ActionCable.server => '/cable'
end
