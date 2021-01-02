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

  get    '/users/auto_sign_in' => 'users#auto_sign_in', as: :user_auto_sign_in
  get    '/businesses' => 'businesses#index', as: :businesses
  get    '/businesses/:slug' => 'businesses#show', as: :business
  get    '/carted_items' => 'carted_items#index', as: :carted_items
  post   '/carted_items' => 'carted_items#create'
  delete '/carted_items/:id' => 'carted_items#destroy', as: :destroy_carted_item
  get    '/orders' => 'orders#index', as: :orders
  get    '/orders/:id' => 'orders#show', as: :order
  post   '/orders' => 'orders#create'
end
