Rails.application.routes.draw do
  root 'yoti#index'
  get '/success', to: 'yoti#success'
end
