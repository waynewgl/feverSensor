class CommentAttachment < ActiveRecord::Base
  attr_accessible :comment_id

  belongs_to :comment
  attr_accessible  :content, :image , :image_content_type, :image_file_name, :image_file_size, :image_updated_at

  has_attached_file :image, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/comment_image/:class/comment/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/comment_image/:class/comment/:id/:style_:basename.:extension"



end
