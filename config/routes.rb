Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    post :book, controller: :bookings, action: :create
    get :tick, controller: :bookings
    get :reset, controller: :bookings
    get :print, controller: :bookings
  end
end
