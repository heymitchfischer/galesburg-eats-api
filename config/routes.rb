Rails.application.routes.draw do
  devise_for :users, path: 'users', defaults: { format: :json }
  get    '/users/auto_sign_in' => 'users#auto_sign_in', as: :user_auto_sign_in
  get    '/businesses' => 'businesses#index'
  get    '/businesses/:slug' => 'businesses#show'
  get    '/carted_items' => 'carted_items#index'
  post   '/carted_items' => 'carted_items#create'
  delete '/carted_items/:id' => 'carted_items#destroy'
  get    '/orders' => 'orders#index'
  post   '/orders' => 'orders#create'
end
