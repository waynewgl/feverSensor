class Nickname < ActiveRecord::Base
  attr_accessible :nick_user_id, :nickname, :user_id

  belongs_to :user

  def as_json(options={})
    {
        id: self.id,
        user_id: self.user_id,
        nick_user_id: self.nick_user_id,
        nickname: self.nickname
    }
  end

end
