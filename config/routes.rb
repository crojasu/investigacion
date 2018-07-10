Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'graficos', to: 'pages#graficos'
  get 'tablas', to: 'pages#tablas'
  get 'todos', to: 'rols#todos'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
resources :peliculas
  resources :rols do
    collection { post :import}
  end
  resources :personajes do
    member { patch :activate }
    member { patch :deactivate }
    member { patch :empresa }
  end
end

