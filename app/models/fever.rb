class Fever < ActiveRecord::Base
  attr_accessible :description, :suggestion, :type, :user_id

  belongs_to :users
  has_and_belongs_to_many :users

  def as_json(options={})
    {
        id: self.id,
        type: self.type,
        description: self.description
    }
  end

end
