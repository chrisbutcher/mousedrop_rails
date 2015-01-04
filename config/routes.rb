Rails.application.routes.draw do
  resource :paste, only: [:show, :create]
  
  devise_for :users

  root :to => 'welcome#index'
end
