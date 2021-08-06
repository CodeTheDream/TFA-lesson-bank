Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#landing_page'

  get '/search' => 'pages#search', :as => 'search_page'

  resources :documents
  resources :courses do
    member do
      get :download
    end 
    resources :lessons 
    # do
    # member do
    #   get :download
    # end
    # end
    resources :documents do
      collection do
        get :course_index
      end
    end
  end
  resources :lessons do
    member do
      get :download
    end
    resources :documents do
      collection do
        get :lesson_index
      end
    end
  end
  resources :tags
  resources :key_words

end
