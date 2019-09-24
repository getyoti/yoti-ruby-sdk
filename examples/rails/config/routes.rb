Rails.application.routes.draw do
  root 'yoti#index'
  get '/profile', to: 'yoti#profile'
  get '/dynamic-share', to: 'yoti#dynamic_share'
end
