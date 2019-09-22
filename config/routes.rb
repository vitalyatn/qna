Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    delete :delete_file_attachment, on: :member
    resources :answers, shallow: true do
      member do
        patch :better
        delete :delete_file_attachment
      end
    end
  end
end
