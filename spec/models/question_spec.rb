require 'spec_helper'

describe Question do

  it "is valid with a body, user_id and track_id" do
    question = Question.new(user_id: 1, track_id: 1, body: "Dude, where is my car?")
    expect(question).to be_valid
  end

  it "should be invalid without a user_id" do
    question = Question.new(track_id: 1, body: "Dude, where is my car?")
    expect(question).to have(1).errors_on(:user_id)
  end

  it "should be invalid without a track_id" do
    question = Question.new(user_id: 1, body: "Dude, where is my car?")
    expect(question).to have(1).errors_on(:track_id)
  end

  it "should be invalid without a body" do
    question = Question.new(user_id: 1, track_id: 1)
    expect(question).to have(1).errors_on(:body)
  end

end
