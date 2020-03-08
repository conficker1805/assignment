Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope module: :api do
    namespace :v1 do
      constraints format: :json do
        resources :answers, only: %w[index create]
        resources :questions, only: [] do
          collection do
            get :scored
            get :distributions
            get :demographic
          end
        end
      end
    end
  end
end
