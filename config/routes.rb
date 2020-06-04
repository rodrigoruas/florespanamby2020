Rails.application.routes.draw do
  get 'stripe_payments/new'

  mount StripeEvent::Engine, at: '/stripe-webhooks'
  mount RailsAdmin::Engine => '/master_admin', as: 'rails_admin'
  require "sidekiq/web"

  post "/update_price", to: "orders#update_price"

  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get '/home' => 'pages#home'
  root to: 'pages#home'
  
  get "termos", to: "pages#terms"
  get "/sobre-nos", to: "pages#about", as: :about
  get "/dia-das-maes", to: "pages#mothers", as: :mothers
  get "/promocoes", to: "pages#promo", as: :promo
  get "produtos/busca", to: "products#search_results"
  get "/verificando_pagamento", to: 'payments#postback', as: :postback
  resources :searches
  resources :products, only: [:index, :show], param: :slug, path: "produtos"  do
    collection do
      post :search, to: 'rooms#create_search'
      get :search_results, as: :search_results
    end
  end
  resources :order_details, path: "carrinho"
  resources :categories, path: "categorias", only: [:show], param: :slug do
    resources :sub_categories, path: "sub-categorias", only: [:show], param: :slug
  end
  resources :orders, only: [:new, :create, :show, :update, :index], path: "pedido" do
    resources :stripe_payments, only: :new
    resources :payments, only: [:new, :create, :index]

    get "update_price_coupon", to: "orders#update_price_coupon"
  end


  resources :coupons, only: [:edit, :update]

  namespace :admin do
    post "/update_special", to: "special_orders#update_special"
    post "/update_price", to: "orders#update_price"
    get '/dashboard', to: 'pages#dashboard'
    get '/mapa-de-hoje', to: 'pages#mothers_map'
    resources :products, param: :slug
    get "/list", to: "products#list"
    resources :orders do
      get "/print", to: "orders#print"
      get "/receipt", to: "orders#receipt"
    end
    post "/send_email", to: "orders#send_email"
    get "/product_list", to: "orders#product_list"
    get "/ordens_pendentes", to: "orders#not_paid_orders", as: :not_paid_orders
    resources :special_orders do
      resources :order_details
      resources :orders
    end
    resources :delivery_costs
    resources :categories, param: :slug, path: "categorias" do
      resources :sub_categories, param: :slug, path: "sub-categorias"
    end
    resources :coupons
    resources :blocked_dates, only: [:index, :new, :create, :destroy]
  end

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
