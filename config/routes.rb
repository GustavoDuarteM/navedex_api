Rails.application.routes.draw do
  resource :login, only: [:create]
end
