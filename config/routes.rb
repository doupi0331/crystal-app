Rails.application.routes.draw do
  devise_for :users, :skip => [:password, :registrations], :controllers => {:registrations => "user/registrations"}
  as :user do

    get "users/edit" => "user/registrations#edit", :as => :edit_user_registration
    patch "/users" => "user/registrations#update", :as => :user_registration
    put "/users" => "user/registrations#update"
    
    #get "/users/sign_up" => "user/registrations#new", :as => :new_user_registration
    #post "/users" => "user/registrations#create"
  end
  
  
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
  
  post 'cancel_trade_item/:id' => 'trades#cancel_trade_item', as: "cancel_trade_item", defaults: { format: 'js' } ###
  get 'add_trade_item/:id' => 'trades#add_trade_item', as: "add_trade_item"
  
  # api
  match 'products/product_api', :via => :all
  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
    post "/login" => "auth#login"
    post "/logout" => "auth#logout"
    resources :members, except: [:destroy, :index]
    get "/members/trades/:id" => "members#trades"
    resources :trades, only: [:show]
  end
  
  
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
