Rails.application.routes.draw do
  root 'yoti#index'
  get '/profile', to: 'yoti#profile'
end
