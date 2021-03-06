require 'spec_helper'

describe Api::QuestionsController, :type => :controller do
  context "Voting on Questions" do

    before do
      client = stub(publish: nil)
      Faye::Client.stub(:new).with('http://localhost:9292/faye').and_return(client)
    end

    describe "Voting on a particular question" do

      it "should increment by one with a vote" do
        question = Question.create(body: "What's happening yall!!??", user_id: 1, track_id: 2)
        post "/api/tracks/2/questions/#{question.id}/vote", vote: {user_id: 1}

        expect(question.reload.vote_count).to eq 1
      end

      it "should create a record in the votes table" do
        question = Question.create(body: "What's happening yall!!??", user_id: 1, track_id: 2)
        expect {
          post "/api/tracks/2/questions/#{question.id}/vote", vote: {user_id: 1}
        }.to change(Vote, :count).by(1)
      end

      it "should prevent a user from voting more than once on a question" do
        question = Question.create(body: "What's happening yall!!??", user_id: 1, track_id: 2)
        post "/api/tracks/2/questions/#{question.id}/vote", vote: {user_id: 1}
        post "/api/tracks/2/questions/#{question.id}/vote", vote: {user_id: 1}
        post "/api/tracks/2/questions/#{question.id}/vote", vote: {user_id: 1}

        expect(question.reload.vote_count).to eq 1
      end
    end
  end
end
