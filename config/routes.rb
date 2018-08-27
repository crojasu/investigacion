Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'graficos', to: 'pages#graficos'
  get 'tablas', to: 'pages#tablas'
  get 'todos', to: 'rols#todos'
  get 'graficosgenerales', to: 'pages#graficosgenerales'
  # get 'contacto', 'to messages#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'contacto', to: 'messages#new', as: 'new_message'
  post 'contacto', to: 'messages#create', as: 'create_message'

resources :peliculas

  resources :rols do
    collection { post :import}
  end

  resources :personajes do
    member { patch :activate }
    member { patch :deactivate }
    member { patch :empresa }
  end

    resources :peliculas do
      collection {post :import}
      collection {post :import_imbd}
    end

end

