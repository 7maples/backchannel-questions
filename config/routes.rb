BackchannelQuestions::Application.routes.draw do

  namespace :api do
    resources :questions, only: [:index, :create]
    get '/questions/:track_id', to: "questions#show", as: "track_questions"

    post '/questions/vote', to: "questions#update", as: "votes"
  end


end
