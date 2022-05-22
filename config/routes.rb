Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  namespace :api do
    namespace :v1 do
      resources :articles, except: %i[edit new] do
        post :favorite, on: :member, action: :add_favorite
        delete :favorite, on: :member, action: :remove_favorite
      end
    end
  end
end
