Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations"}
  resources :members
  resources :trades, only: [:show, :destroy]
  
  root 'pages#index'
  get 'search_members' => 'members#search' 
  get 'coin_member/:id' => 'members#coin', :as => "coin_member"
  post 'add_coin/:id' => 'members#add_coin', :as => "add_coin"
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
