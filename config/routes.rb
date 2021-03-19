Rails.application.routes.draw do
  resource :login, only: [:create]
  resource :sign_up, only: [:create]
  
  scope :naver do
    get '/index', to: 'navers#index', as: 'navers_index'
    get '/show/:id', to: 'navers#show', as: 'navers_show'
    patch '/update', to: 'navers#update', as: 'navers_update'
    post '/store', to: 'navers#store', as: 'navers_store'
    delete '/delete/:id', to: 'navers#delete', as: 'navers_delete'
  end
end
