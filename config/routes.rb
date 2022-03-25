Rails.application.routes.draw do
  devise_for :business_users,
    controllers: {
      sessions: 'business_users/sessions',
      registrations: 'business_users/registrations'
    },
    path: 'business_users',
    defaults: { format: :json }

  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    },
    path: 'users',
    defaults: { format: :json }

  get '/users/auto_sign_in' => 'users#auto_sign_in', as: :user_auto_sign_in

  scope path: '/businesses' do
    get '/' => 'businesses#index', as: :businesses
    get '/:slug' => 'businesses#show', as: :business
  end

  scope path: '/carted_items' do
    get '/' => 'carted_items#index', as: :carted_items
    post '/' => 'carted_items#create'
    delete '/:id' => 'carted_items#destroy', as: :destroy_carted_item
  end

  scope path: '/orders' do
    get '/' => 'orders#index', as: :orders
    get '/:id' => 'orders#show', as: :order
    post '/' => 'orders#create'
  end
end
