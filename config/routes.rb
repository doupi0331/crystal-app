Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations"}
  resources :members
  resources :trades, except: [:edit, :update, :new, :create]
  resources :prod_types, except: [:destroy, :show]
  resources :products, except: [:destroy, :show]

  root 'pages#index'
  get 'search_members' => 'members#search'
  get 'members/coin/:id' => 'members#coin', :as => "coin"
  post 'members/coin/:id' => 'members#add_coin'
  get 'coin/:id' => 'members#add_coin'
  get 'members/trade/:id' => 'trades#new', :as => "new_trade"
  post 'members/trade/:id' => 'trades#create'
  get 'search_products' => 'products#search'
  
  match 'products/product_api', :via => :all

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
