require 'spec_helper'

describe Api::QuestionsController, :type => :controller do

  context "Retrieving Questions" do

    context "For a specific track" do

      describe "GET /api/tracks/:track_id/questions" do

        it "should return a list of questions for a specific track" do
          q1 = Question.create(body: "How big is the moon?", user_id: 1, track_id: 2)
          q2 = Question.create(body: "How far away is the sun from Earth?", user_id: 2, track_id: 3)
          questions = [q1].to_json

          get "/api/tracks/2/questions"
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq questions
        end
      end
    end
  end

  context "Posting Questions" do

    context "To a specific track" do

      describe "POST /api/questions" do

        it " should create a question with valid parameters" do
          client = stub(publish: nil)
          Faye::Client.stub(:new).with('http://localhost:9292/faye').and_return(client)

          post "/api/tracks/3/questions", question: { user_id:1,
                                           body: "Where is Andromeda?" }
          question = Question.last
          expect(last_response.status).to eq 201
          expect(last_response.body).to eq question.to_json
        end

        describe "with invalid parameters" do

          it "should return an error message and not create a new question when missing user_id" do
            post "/api/tracks/3/questions", question: { body: "Where did Frank go?" }

            error = {:error => {"user_id" => ["can't be blank"]}}
            expect(last_response.status).to eq 400
            expect(last_response.body).to eq error.to_json
          end

          it "should return an error message and not create a new question when missing body" do
            post "/api/tracks/3/questions", question: { user_id:1 }

            error = {:error => {"body" => ["can't be blank"]}}
            expect(last_response.status).to eq 400
            expect(last_response.body).to eq error.to_json
          end
        end
      end
    end
  end
end
