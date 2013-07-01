require 'spec_helper'

describe Vote do

  it "is valid with a user_id and question_id" do
    vote = Vote.new(user_id: 1, question_id: 1)
    expect(vote).to be_valid
  end

  it "should be invalid without a user_id" do
    vote = Vote.new(question_id: 1)
    expect(vote).to have(1).errors_on(:user_id)
  end
end
