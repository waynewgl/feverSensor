class Post < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user
  has_many :favoriates
  has_many :post_attachments
  has_many :comments

  def as_json(options={})
    {
        id: self.id,
        title: self.title,
        content: self.content,
        author: self.author,
        date: self.date,
        #comments: self.comments,
        #attachment: self.post_attachments
    }
  end

end
