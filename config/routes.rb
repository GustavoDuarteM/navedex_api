Rails.application.routes.draw do
  resource :login, only: [:create]
  resource :sign_up, only: [:create]
end
