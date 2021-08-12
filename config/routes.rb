Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#landing_page'
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # resources :courses do
  #   put :favorite, on: :member
  # end

  get '/search' => 'pages#search', :as => 'search_page'
  


  resources :documents
  resources :courses do 
    member do
      get :favorite
      get :unfavorite
      # put :favorite
    end
    member do
      get :download
    end 
    resources :lessons
    resources :documents do
      collection do
        get :course_index
      end
    end
    
  end
  resources :lessons do
    resources :documents do
      collection do
        get :lesson_index
      end
    end
  end
  resources :tags
  resources :key_words

end
