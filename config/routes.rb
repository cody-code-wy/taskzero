Rails.application.routes.draw do
  get '/', to: 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :users, except: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
