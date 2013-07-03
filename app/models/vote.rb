class Vote < ActiveRecord::Base
  attr_accessible :user_id, :question_id

  validates_presence_of :user_id, :question_id

  def self.add_for_user_question(user_id, question)
    return nil unless question
    vote = where(user_id: user_id, question_id: question.id).first
    return nil if vote || user_id == question.user_id

    transaction do
      create(user_id: user_id, question_id: question.id)
      question.increment_vote
    end
  end
end
