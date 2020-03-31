Rails.application.routes.draw do
  resources :transactions, only: %i[create]
  resources :checking_accounts, only: %i[show create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'
end
