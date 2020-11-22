Rails.application.routes.draw do
  devise_for :users, path: 'users', defaults: { format: :json }
  get    '/test' => 'cookies#test'
  post   '/store_cookie' => 'cookies#store_cookie'
  post   '/validate_cookie' => 'cookies#validate_cookie'
  delete '/remove_cookie' => 'cookies#remove_cookie'
  get    '/businesses' => 'businesses#index'
  get    '/businesses/:slug' => 'businesses#show'
  get    '/carted_items' => 'carted_items#index'
  post   '/carted_items' => 'carted_items#create'
  delete '/carted_items/:id' => 'carted_items#destroy'
  post   '/orders' => 'orders#create'
end
