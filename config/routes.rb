Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
resources :peliculas do
  resources :rols
  resources :personajes do
    member { patch :activate }
    member { patch :deactivate }
  end
end
end
