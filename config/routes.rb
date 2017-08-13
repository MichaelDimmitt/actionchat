Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}
  authenticate :user do
    resources :rooms do
      resources :messages
    end
  end
  resources :users, :only => [:index, :show, :create, :new, :edit] 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'rooms#show', id: 1
  mount ActionCable.server => '/cable'
  post '/rooms/create', to: 'rooms#create'

end
