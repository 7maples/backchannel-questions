class Question < ActiveRecord::Base
  attr_accessible :body, :track_id, :user_id

  validates_presence_of :user_id, :track_id, :body

  def increment_vote
    Question.increment_counter(:vote_count, self.id)
  end
end
