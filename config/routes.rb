Rails.application.routes.draw do
  devise_for :users, path: 'users', defaults: { format: :json }
  get    '/test' => 'cookies#test'
  post   '/store_cookie' => 'cookies#store_cookie'
  post   '/validate_cookie' => 'cookies#validate_cookie'
  delete '/remove_cookie' => 'cookies#remove_cookie'
  get    '/businesses' => 'businesses#index'
  get    '/businesses/:slug' => 'businesses#show'
end
