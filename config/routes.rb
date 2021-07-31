Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :artists do
        member do
          get :albums
        end
        collection do
          get 'artists'
        end
      end
      resources :albums do
        member do
          get :songs
        end
      end
      resources :songs, :path => "genres" do
        member do
          get :songs, :key => "genre_name", :path => "random_song"
        end
      end
    end
  end
end
