class Follower < ActiveRecord::Base

  belongs_to :user

  attr_accessible :follower_id, :user_id
end
