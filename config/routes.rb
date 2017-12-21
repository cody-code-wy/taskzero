Rails.application.routes.draw do
  resources :tasks
  resources :projects
  resources :contexts
  get '/', to: 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resource :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
