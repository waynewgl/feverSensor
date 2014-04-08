class Comment < ActiveRecord::Base
  attr_accessible :content, :parent_id, :post_id, :user_id

  has_many :comment_attachments
  belongs_to :post


  def as_json(options={})
    {
        id: self.id,
        parent_id: self.parent_id,
        content: self.content,
        comment_replies: self.child_comments_nested
    }
  end



  # returns an array of category id's
  # that represents the children (and children of children and...) of
  # this category
  # this can be used to filter articles by categories and include all
  # subcategories at the same time
  def child_comments_all_nested

    children = Comment.where(["parent_id = ?",self.id])
    ret = nil
    if children.empty?
      ret = children
    else
      ret = Array.new
      for c in children
        ret << c
        ret = ret + c.child_categories
      end
    end
    return ret
  end

  def child_comments_nested

    children = Comment.where(["parent_id = ?",self.id])
    return children
  end

  def parent_comments_nested

    parent = Comment.where(["id = ?",self.parent_id])
    return parent
  end

end
