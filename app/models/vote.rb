class Vote < ActiveRecord::Base
  attr_accessible :user_id, :question_id

  validates_presence_of :user_id, :question_id
end
