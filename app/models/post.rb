class Post < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user

  def as_json(options={})
    {
        id: self.id,
        content: self.content
    }
  end

end
