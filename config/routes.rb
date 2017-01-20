Rails.application.routes.draw do
  post   '/login',   to: 'sessions#login'
  post   '/signup',  to: 'sessions#register'
  delete '/logout',  to: 'sessions#logout'

  get    '/records',      to: 'mass_index_records#index',    as: 'records_index'
  post   '/records',      to: 'mass_index_records#create',   as: 'records_create'
  delete '/records/:id',  to: 'mass_index_records#destroy',  as: 'records_destroy'
end
