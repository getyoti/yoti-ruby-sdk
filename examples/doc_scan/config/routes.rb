Rails.application.routes.draw do
  root 'yoti#index'
  get '/success', to: 'yoti#success'
  get '/media', to: 'yoti#media'
  get '/error', to: 'yoti#error'
end
