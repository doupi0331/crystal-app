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
  
  # api
  match 'products/product_api', :via => :all
  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
    post "/login" => "auth#login"
    post "/logout" => "auth#logout"
    resources :members, except: [:destroy]
  end
  
  
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
