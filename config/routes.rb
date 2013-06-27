BackchannelQuestions::Application.routes.draw do

  namespace :api do
    resources :tracks, only: [] do
      member do
        resources :questions, only: [:index, :create] do
          member do
            post :vote
          end
        end
      end
    end
  end
end
