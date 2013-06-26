require 'spec_helper'

describe Api::QuestionsController, :type => :controller do

  context "Retrieving Questions" do
    context "For all tracks" do
      describe "GET /api/questions" do
        it "should return a list of all questions" do
          q1 = Question.create(body: "How much wood would a woodchuck chuck?", user_id: 1, track_id: 2)
          q2 = Question.create(body: "If a woodchuck could chuck wood?", user_id: 2, track_id: 3)
          questions = [q1, q2].to_json

          get "/api/questions"

          expect(last_response.status).to eq 200
          expect(last_response.body).to eq questions
        end
      end
    end

    context "For a specific track" do

      describe "GET /api/questions/:track_id" do

        it "should return a list of questions for a specific track" do
          q1 = Question.create(body: "How big is the moon?", user_id: 1, track_id: 2)
          q2 = Question.create(body: "How far away is the sun from Earth?", user_id: 2, track_id: 3)
          questions = [q1].to_json

          get "/api/questions/#{q1.track_id}"
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq questions
        end

        it "should return an error message if track doesn't exist" do
          q1 = Question.create(body: "What's happening yall!!??", user_id: 1, track_id: 2)
          get "/api/questions/77"

          error = {:error => "No track found"}
          expect(last_response.status).to eq 404
          expect(last_response.body).to eq error.to_json
        end
      end
    end
  end

  context "Posting Questions" do

    context "To a specific track" do

      describe "POST /api/questions" do

        it " should create a question with valid parameters" do
          client = stub()
          Faye::Client.stub(:new).with('http://localhost:9292/faye').and_return(client)
          client.stub(:publish)

          post "/api/questions", question: { user_id:1,
                                           track_id:3,
                                           body: "Where is Andromeda?" }
          question = Question.last
          expect(last_response.status).to eq 201
          expect(last_response.body).to eq question.to_json
        end

        describe "with invalid parameters" do

          it "should return an error message and not create a new question when missing track_id" do
            post "/api/questions", question: { user_id:1,
                                             body: "Where is my shoe?" }

            error = {:error => {"track_id" => ["can't be blank"]}}
            expect(last_response.status).to eq 400
            expect(last_response.body).to eq error.to_json
          end

          it "should return an error message and not create a new question when missing user_id" do
            post "/api/questions", question: { track_id:3,
                                             body: "Where did Frank go?" }

            error = {:error => {"user_id" => ["can't be blank"]}}
            expect(last_response.status).to eq 400
            expect(last_response.body).to eq error.to_json
          end

          it "should return an error message and not create a new question when missing body" do
            post "/api/questions", question: { user_id:1,
                                             track_id:3 }

            error = {:error => {"body" => ["can't be blank"]}}
            expect(last_response.status).to eq 400
            expect(last_response.body).to eq error.to_json
          end

        end
      end
    end

  end

end
