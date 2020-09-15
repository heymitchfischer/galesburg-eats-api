Rails.application.routes.draw do
  devise_for :users, path: 'users', defaults: { format: :json }
end
