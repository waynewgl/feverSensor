class BlackList < ActiveRecord::Base
  attr_accessible :block_user_id, :user_id

  belongs_to :user

end
