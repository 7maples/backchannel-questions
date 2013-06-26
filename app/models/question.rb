class Question < ActiveRecord::Base
  attr_accessible :body, :track_id, :user_id

  validates_presence_of :user_id, :track_id, :body
end
