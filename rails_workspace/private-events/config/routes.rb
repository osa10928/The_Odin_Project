Rails.application.routes.draw do
  get 'events/new', to: 'events#new'
  get 'events/show', to: 'events#show'
  get 'events/index', to: 'events#index'
 post 'events/new', to: 'events#create'

get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

end
