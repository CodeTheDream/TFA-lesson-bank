Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#landing_page'
  resources :courses do 
    resources :lessons
    resources :documents do
      member do
        get :course_index
      end
    end
  end
  resources :lessons do
    resources :documents do
      member do
        get :lesson_index
      end
    end
  end
end
