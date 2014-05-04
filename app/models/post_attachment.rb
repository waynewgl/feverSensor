class PostAttachment < ActiveRecord::Base


  belongs_to :post

  attr_accessible :note, :post_id
  attr_accessible :title, :content, :image , :image_content_type, :image_file_name, :image_file_size, :image_updated_at

  has_attached_file :image, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/post_image/:class/post/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/post_image/:class/post/:id/:style_:basename.:extension"

  def as_json(options={})
    {
        id: self.id,
        image_url: self.image.url(:content)
    }
  end

end
