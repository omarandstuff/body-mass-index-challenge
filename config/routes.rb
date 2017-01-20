Rails.application.routes.draw do
  post   '/login',   to: 'sessions#login'
  post   '/signup',  to: 'sessions#register'
  delete '/logout',  to: 'sessions#logout'
end
